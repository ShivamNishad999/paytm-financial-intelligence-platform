import 'package:intl/intl.dart';

/// Currency + date formatting helpers, using `intl` per the brief.
class Formatters {
  Formatters._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrDecimal = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String currency(num? value, {bool decimals = false}) {
    if (value == null) return '₹0';
    return decimals ? _inrDecimal.format(value) : _inr.format(value);
  }

  static String compactCurrency(num? value) {
    if (value == null) return '₹0';
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    }
    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    }
    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    }
    return currency(value);
  }

  static String shortDate(DateTime date) => DateFormat('d MMM').format(date);

  static String weekday(DateTime date) => DateFormat('EEE').format(date);

  static String fullDate(DateTime date) => DateFormat('d MMM, yyyy').format(date);
}
