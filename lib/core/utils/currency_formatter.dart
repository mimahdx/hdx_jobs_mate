import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  /// Formats a number into a currency string
  /// Example: 1234.5 -> $1,234.50
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Formats a number into a compact currency string
  /// Example: 1234.5 -> $1.2K
  static String formatCompact(double amount) {
    if (amount < 1000) {
      return format(amount);
    }

    if (amount < 1000000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }

    return '\$${(amount / 1000000).toStringAsFixed(1)}M';
  }

  /// Parses a currency string into a double
  /// Example: $1,234.50 -> 1234.5
  static double? parse(String text) {
    try {
      // Remove currency symbol and any whitespace
      final cleanText = text.replaceAll(_formatter.currencySymbol, '').trim();
      return _formatter.parse(cleanText).toDouble();
    } catch (e) {
      return null;
    }
  }

  /// Returns just the currency symbol
  static String get currencySymbol => _formatter.currencySymbol;

  /// Formats a number with a plus or minus sign
  /// Example: 1234.5 -> +$1,234.50, -1234.5 -> -$1,234.50
  static String formatWithSign(double amount) {
    if (amount > 0) {
      return '+${format(amount)}';
    }
    return format(amount);
  }

  /// Formats a number without decimal places
  /// Example: 1234.5 -> $1,235
  static String formatWholeNumber(double amount) {
    return NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    ).format(amount.round());
  }
}