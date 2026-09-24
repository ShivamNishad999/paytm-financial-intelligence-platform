/// Small null/type-safe JSON coercion helpers shared by every model's
/// `fromJson`. The backend serializes BigDecimal as JSON numbers and
/// LocalDate/LocalDateTime as ISO-8601 strings (Spring Boot's default
/// Jackson config), but every field is still nullable in practice since
/// several entity columns allow null — never assume a field is present.
double asDouble(dynamic value, [double fallback = 0]) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}

int asInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

String asString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  return value.toString();
}

DateTime? asDateTime(dynamic value) {
  if (value == null) return null;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
