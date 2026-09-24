import '../../core/utils/json_parsing.dart';

/// Maps `OpportunityDTO` from the backend (`GET /api/opportunities`, and
/// embedded as `opportunities[]` inside `GET /api/dashboard`).
///
/// Important: the backend supplies no id, no status, and no "expected
/// impact" number. Per the AI reality check, this is a deterministic
/// rule-based detector, not an LLM — copy in the UI must not imply
/// otherwise, and must never fabricate an impact percentage.
class OpportunityModel {
  final String type;
  final String priority; // HIGH | MEDIUM (as emitted by OpportunityService)
  final String message;
  final String action;

  const OpportunityModel({
    required this.type,
    required this.priority,
    required this.message,
    required this.action,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      type: asString(json['type']),
      priority: asString(json['priority'], 'MEDIUM'),
      message: asString(json['message']),
      action: asString(json['action']),
    );
  }

  bool get isHighPriority => priority.toUpperCase() == 'HIGH';
}
