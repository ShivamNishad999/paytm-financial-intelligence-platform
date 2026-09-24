import '../../core/utils/json_parsing.dart';

/// Maps the `Merchant` entity (`/api/merchants`). Used by mock login
/// and, later, the Profile screen. Phase 1 only ever constructs this
/// from local mock data (see MockAuthService) since there's no real
/// auth endpoint to fetch it from yet.
class MerchantModel {
  final int? merchantId;
  final String merchantName;
  final String businessType;
  final String city;
  final String? address;
  final String? phone;
  final String? email;

  const MerchantModel({
    this.merchantId,
    required this.merchantName,
    required this.businessType,
    required this.city,
    this.address,
    this.phone,
    this.email,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      merchantId: json['merchantId'] == null ? null : asInt(json['merchantId']),
      merchantName: asString(json['merchantName'], 'Merchant'),
      businessType: asString(json['businessType']),
      city: asString(json['city']),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  factory MerchantModel.mockDemo() => const MerchantModel(
        merchantId: null,
        merchantName: 'Rajesh Kumar',
        businessType: 'General Store',
        city: 'Lucknow',
      );
}
