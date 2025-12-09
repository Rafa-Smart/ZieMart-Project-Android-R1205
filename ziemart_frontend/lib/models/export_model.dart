// lib/models/export_model.dart
import 'package:ziemart_frontend/models/order_model.dart';

class ExportData {
  final String fileName;
  final List<Order> orders;
  final DateTime exportDate;
  final String exportType; // 'excel', 'pdf', 'word'

  ExportData({
    required this.fileName,
    required this.orders,
    required this.exportDate,
    required this.exportType,
  });
}