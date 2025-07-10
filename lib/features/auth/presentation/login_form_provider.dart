import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFormState {
  final String email;
  final String password;
  final bool isLoading;
  final String? error;
  final bool obscurePassword;

  LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.obscurePassword = true,
  });

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

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  void setEmail(String value) => state = state.copyWith(email: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  void setError(String? value) => state = state.copyWith(error: value);
  void toggleObscurePassword() => state = state.copyWith(obscurePassword: !state.obscurePassword);

  Future<void> submit() async {
    setLoading(true);
    setError(null);
    await Future.delayed(Duration(seconds: 1)); // Simulate network
    if (state.email == 'test@test.com' && state.password == 'password') {
      // Success
      setLoading(false);
    } else {
      setLoading(false);
      setError('Invalid credentials');
    }
  }
}

final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) => LoginFormNotifier()); 