// lib/utils/formatter.dart
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

String formatCurrency(double amount) {
  return currencyFormatter.format(amount);
}

String formatDate(DateTime date, {String format = 'dd/MM/yyyy HH:mm'}) {
  return DateFormat(format).format(date);
}

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / 1048576).toStringAsFixed(1)} MB';
}