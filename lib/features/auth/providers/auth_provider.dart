import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../data/user_model.dart';

// Auth state model
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isOfflineMode;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isOfflineMode = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isOfflineMode,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  late final Box<UserModel> _usersBox;
  static const _sessionKey = 'logged_in_user_id';

  @override
  AuthState build() {
    _usersBox = Hive.box<UserModel>('users');
    _restoreSession();
    return const AuthState();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString(_sessionKey);
    if (savedUserId != null) {
      final user = _usersBox.get(savedUserId);
      if (user != null) {
        state = state.copyWith(user: user);
      }
    }
  }

  Future<void> _saveSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, userId);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    await Future.delayed(const Duration(milliseconds: 400)); // Smooth UX

    // Check if email already exists
    final exists = _usersBox.values.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (exists) {
      state = state.copyWith(
        isLoading: false,
        error: 'An account with this email already exists.',
      );
      return;
    }

    final user = UserModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      passwordHash: _hashPassword(password),
      createdAt: DateTime.now(),
    );

    await _usersBox.put(user.id, user);
    await _saveSession(user.id);

    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    await Future.delayed(const Duration(milliseconds: 400)); // Smooth UX

    try {
      final user = _usersBox.values.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (user.passwordHash != _hashPassword(password)) {
        state = state.copyWith(
          isLoading: false,
          error: 'Incorrect password. Please try again.',
        );
        return;
      }

      await _saveSession(user.id);
      state = state.copyWith(user: user, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'No account found with this email.',
      );
    }
  }

  Future<void> logout() async {
    await _clearSession();
    state = const AuthState();
  }
}
