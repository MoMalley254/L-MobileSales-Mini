import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_model.dart';

final authProviderNotifier = NotifierProvider<AuthNotifier, AuthModel>(
  AuthNotifier.new
);

class AuthNotifier extends Notifier<AuthModel> {

  @override
  AuthModel build() {
    final validator = AuthModel();
    state = validator;
    return state;
  }

  void validatePassword(String password) {
    state = state.copyWith(
      password: password,
      hasMinLength: password.length >= 8,
      hasUppercaseLetter: password.contains(RegExp(r'[A-Z]')),
      hasANumber: password.contains(RegExp(r'[0-9]')),
      hasASpecialCharacter: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    );
  }

  void updateUsername(String username) {
    state = state.copyWith(
      username: username
    );
  }

  void updateEmail(String email) {
    state = state.copyWith(
      email: email
    );
  }
}