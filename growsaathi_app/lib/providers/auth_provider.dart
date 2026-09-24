import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/local_storage_service.dart';
import '../models/merchant/merchant_model.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/mock_auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => MockAuthService());

class AuthState {
  final bool isAuthenticated;
  final MerchantModel? merchant;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.merchant,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    MerchantModel? merchant,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      merchant: merchant ?? this.merchant,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService)
      : super(AuthState(isAuthenticated: LocalStorageService.instance.hasMockSession()));

  final AuthService _authService;

  Future<void> login({required String identifier, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final merchant = await _authService.login(identifier: identifier, password: password);
      await LocalStorageService.instance.setMockSession(true);
      state = AuthState(isAuthenticated: true, merchant: merchant, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await LocalStorageService.instance.setMockSession(false);
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
