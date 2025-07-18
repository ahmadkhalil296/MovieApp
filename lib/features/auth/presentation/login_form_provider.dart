import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provides the state for the login form, including email, password, loading status, error message, and password visibility.
class LoginFormState {
  // User's email input
  final String email;
  // User's password input
  final String password;
  // Indicates if a login operation is in progress
  final bool isLoading;
  // Stores any error message from login attempt
  final String? error;
  // Controls whether the password is obscured in the UI
  final bool obscurePassword;

  LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.obscurePassword = true,
  });

  // Returns a new state with updated values, preserving unchanged fields
  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    bool? obscurePassword,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

// Notifier class to manage and update the LoginFormState using Riverpod
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  // Initializes with default state
  LoginFormNotifier() : super(LoginFormState());

  // Updates the email in the state
  void setEmail(String value) => state = state.copyWith(email: value);
  // Updates the password in the state
  void setPassword(String value) => state = state.copyWith(password: value);
  // Sets the loading status
  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  // Sets an error message
  void setError(String? value) => state = state.copyWith(error: value);
  // Toggles password visibility
  void toggleObscurePassword() => state = state.copyWith(obscurePassword: !state.obscurePassword);

  // Handles the login submission logic
  Future<void> submit() async {
    setLoading(true);
    setError(null);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setError(e.message ?? 'Login failed');
    } catch (e) {
      setLoading(false);
      setError('An unexpected error occurred');
    }
  }
}

// Riverpod provider for the login form state and notifier
final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) => LoginFormNotifier()); 