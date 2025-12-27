import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/core/providers/data_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/models/auth_model.dart';

final authProviderNotifier = AsyncNotifierProvider<AuthNotifier, AuthModel>(
  AuthNotifier.new
);

class AuthNotifier extends AsyncNotifier<AuthModel> {
  final _secureStorage = FlutterSecureStorage();

  static const int maxTries = 3;
  int _currentTry = 0;
  DateTime? _cooldownEnd;

  @override
  Future<AuthModel> build() async {
    final String? savedUserId = await _secureStorage.read(key: 'auth_key');
    if (savedUserId != null && savedUserId.isNotEmpty) {
      return getUserDataFromSaved(savedUserId);
    } else {
      return AuthModel();
    }
  }

  Future<AuthModel> getUserDataFromSaved(String userId) async {
    final data = await ref.read(appDataAsyncProvider.future);

    final users = data.users;
    final user = users.firstWhereOrNull((u) => u.id == userId);
    if (user != null) {
      return AuthModel(
        username: user.username,
        email: user.email,
        password: user.password,
        hasMinLength: true,
        hasUppercaseLetter: true,
        hasANumber: true,
        hasASpecialCharacter: true,
        userData: user,
      );
    } else {
      return AuthModel();
    }
  }

  void validatePassword(String password) {
    final current = state.value ?? AuthModel();

    state = AsyncData(
      current.copyWith(
        password: password,
        hasMinLength: password.length >= 8,
        hasUppercaseLetter: password.contains(RegExp(r'[A-Z]')),
        hasANumber: password.contains(RegExp(r'[0-9]')),
        hasASpecialCharacter:
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    );
  }

  void updateUsername(String username) {
    final current = state.value ?? AuthModel();

    state = AsyncData(
      current.copyWith(username: username),
    );
  }

  void updateEmail(String email) {
    final current = state.value ?? AuthModel();

    state = AsyncData(
      current.copyWith(email: email),
    );
  }

  Future<void> login(String username, String password, bool rememberMe) async {
    if (_cooldownEnd != null && DateTime.now().isBefore(_cooldownEnd!)) {
      final remaining = _cooldownEnd!.difference(DateTime.now());
      state = AsyncError(
          'Too many attempts. Try again in ${remaining.inSeconds} seconds.',
          StackTrace.current);
      return;
    }

    try {
      final data = await ref.read(appDataAsyncProvider.future);

      final users = data.users;
      final user = users.firstWhere(
          (u) => u.username == username && u.password == password,
          orElse: () => throw Exception('Invalid Credentials')
      );

      _currentTry = 0;
      _cooldownEnd = null;
      await _secureStorage.write(key: 'auth_token', value: user.id);
      if (rememberMe) {
        await _secureStorage.write(key: 'username', value: username);
        await _secureStorage.write(key: 'password', value: password);
      }
      state = AsyncData(
        AuthModel(userData: user),
      );
    } catch (e) {
      _currentTry++;

      if (_currentTry >= maxTries) {
        _cooldownEnd = DateTime.now().add(const Duration(seconds: 30));
        state = AsyncError(
          'Too many attempts. Try again in 30 seconds.',
          StackTrace.current,
        );
      } else {
        state = AsyncError(
          'Invalid credentials. Attempt $_currentTry of $maxTries.',
          StackTrace.current,
        );
      }
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    state = AsyncData(AuthModel());
  }
}