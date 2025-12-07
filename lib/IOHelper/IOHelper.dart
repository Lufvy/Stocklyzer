import 'package:intl/intl.dart';

class IOHelper {
  static bool sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String formatPrice(double value) {
    final f = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    );
    return f.format(value);
  }

  static int getPercentageDigit(double value) {
    // Multiplies the decimal (e.g., 0.95) by 100 and truncates the result
    return (value * 100).truncate();
  }
}
