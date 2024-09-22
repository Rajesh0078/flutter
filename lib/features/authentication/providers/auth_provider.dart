import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Provider for managing authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Authentication State class to manage authentication status
class AuthState {
  final bool isAuthenticated;

  AuthState({
    required this.isAuthenticated,
  });

  // Utility method to create a new AuthState
  AuthState copyWith({
    bool? isAuthenticated,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// AuthNotifier for managing authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier() : super(AuthState(isAuthenticated: false)) {
    checkAuth();
  }

  // Check if there is an auth token to determine if the user is logged in
  Future<void> checkAuth() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token != null) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  // Method to log in the user and save the token
  Future<void> login(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    state = state.copyWith(isAuthenticated: true);
  }

  // Method to log out the user and remove the token
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    state = state.copyWith(isAuthenticated: false);
  }
}
