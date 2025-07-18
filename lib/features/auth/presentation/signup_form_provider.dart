import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupFormState {
  final String fullName;
  final String email;
  final String password;
  final bool isLoading;
  final String? error;
  final bool obscurePassword;

  SignupFormState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.obscurePassword = true,
  });

  SignupFormState copyWith({
    String? fullName,
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    bool? obscurePassword,
  }) {
    return SignupFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

class SignupFormNotifier extends StateNotifier<SignupFormState> {
  SignupFormNotifier() : super(SignupFormState());

  void setFullName(String value) => state = state.copyWith(fullName: value);
  void setEmail(String value) => state = state.copyWith(email: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  void setError(String? value) => state = state.copyWith(error: value);
  void toggleObscurePassword() => state = state.copyWith(obscurePassword: !state.obscurePassword);

  Future<void> submit() async {
    setLoading(true);
    setError(null);
    try {
      if (state.email.isEmpty || state.password.isEmpty || state.fullName.isEmpty) {
        setLoading(false);
        setError('Please fill all fields');
        return;
      }
      // Create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      // Store additional user info in Firestore
      final user = userCredential.user;
      if (user != null) {
        print('Saving user to Firestore: UID=${user.uid}, fullName=${state.fullName}');
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': state.fullName,
          'email': state.email,
        });
        print('User saved to Firestore successfully.');
      } else {
        print('User is null after signup.');
      }
      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setError(e.message ?? 'Signup failed');
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      setLoading(false);
      setError('An unexpected error occurred');
      print('Signup error: $e');
    }
  }
}

final signupFormProvider = StateNotifierProvider<SignupFormNotifier, SignupFormState>((ref) => SignupFormNotifier()); 