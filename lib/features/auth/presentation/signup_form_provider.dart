import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    await Future.delayed(Duration(seconds: 1)); // Simulate network
    if (state.email.isNotEmpty && state.password.isNotEmpty && state.fullName.isNotEmpty) {
      // Success
      setLoading(false);
    } else {
      setLoading(false);
      setError('Please fill all fields');
    }
  }
}

final signupFormProvider = StateNotifierProvider<SignupFormNotifier, SignupFormState>((ref) => SignupFormNotifier()); 