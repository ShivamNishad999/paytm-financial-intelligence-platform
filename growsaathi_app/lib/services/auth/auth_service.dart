import '../../models/merchant/merchant_model.dart';

/// Abstraction the UI/provider layer talks to. There is no real
/// `/api/auth/login` endpoint on the backend today (confirmed against
/// the source — no AuthController, SecurityConfig permits all
/// requests), so [MockAuthService] is the only implementation for now.
/// Swapping in real JWT auth later means adding a `LiveAuthService`
/// here and changing one provider wire-up — no screen changes.
abstract class AuthService {
  Future<MerchantModel> login({required String identifier, required String password});
  Future<void> logout();
}
