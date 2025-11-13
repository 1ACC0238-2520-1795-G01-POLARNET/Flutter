import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String symbol = 'S/.'}) {
    final formatter = NumberFormat.currency(
      locale: 'es_PE',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount) {
    final formatter = NumberFormat.compact(locale: 'es_PE');
    return 'S/. ${formatter.format(amount)}';
  }
}
