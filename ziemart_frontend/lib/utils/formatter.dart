import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatCurrency(double price) {
  return _currencyFormatter.format(price);
}
