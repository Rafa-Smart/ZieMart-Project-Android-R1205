import 'product_model.dart';

class Order {
  final int id;
  final int accountId;
  final int productId;
  final int quantity;
  final double totalPrice;
  final String status; // pending, processing, shipped, delivered, cancelled
  final String orderDate;
  final String? updatedAt;
  final Product? product;

  Order({
    required this.id,
    required this.accountId,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    this.updatedAt,
    this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.tryParse(json['id'].toString()) ?? 0,
      accountId: int.tryParse(json['account_id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      orderDate: json['order_date']?.toString() ?? json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'product_id': productId,
      'quantity': quantity,
      'total_price': totalPrice,
      'status': status,
      'order_date': orderDate,
    };
  }

  // Helper untuk status badge color
  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}