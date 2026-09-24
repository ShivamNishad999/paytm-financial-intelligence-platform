import '../../models/merchant/merchant_model.dart';
import 'auth_service.dart';

/// Local-only login for the prototype, per the brief ("mock login may
/// be allowed if backend authentication is not ready"). Accepts any
/// non-empty identifier/password so the demo flow is never blocked.
class MockAuthService implements AuthService {
  @override
  Future<MerchantModel> login({required String identifier, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Please enter your mobile number/email and password.');
    }

    return MerchantModel.mockDemo();
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
