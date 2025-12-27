import 'package:l_mobile_sales_mini/data/models/user/user_model.dart';

class AuthModel {
  final String username;
  final String email;
  final String password;
  final bool hasMinLength;
  final bool hasUppercaseLetter;
  final bool hasANumber;
  final bool hasASpecialCharacter;
  final User? userData;
  final String? error;

  const AuthModel({
    this.username = '',
    this.email = '',
    this.password = '',
    this.hasMinLength = false,
    this.hasUppercaseLetter = false,
    this.hasANumber = false,
    this.hasASpecialCharacter = false,
    this.userData,
    this.error
  });

  bool get passwordValid =>
      hasMinLength && hasUppercaseLetter && hasANumber && hasASpecialCharacter;

  bool get allInputsProvided => passwordValid && username.isNotEmpty;

  bool get validForPasswordReset => username.isNotEmpty && email.isNotEmpty;

  bool get isAuthenticated => userData != null;

  AuthModel copyWith({
    String? username,
    String? email,
    String? password,
    bool? hasMinLength,
    bool? hasUppercaseLetter,
    bool? hasANumber,
    bool? hasASpecialCharacter,
    User? userData,
    String? error
  }) {
    return AuthModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercaseLetter: hasUppercaseLetter ?? this.hasUppercaseLetter,
      hasANumber: hasANumber ?? this.hasANumber,
      hasASpecialCharacter: hasASpecialCharacter ?? this.hasASpecialCharacter,
      userData: userData ?? this.userData,
      error: error ?? this.error,
    );
  }
}
