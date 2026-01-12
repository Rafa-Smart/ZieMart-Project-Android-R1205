import 'package:flutter/material.dart';
import 'product_model.dart';
import 'user_model.dart';

class Order {
  final int id;
  final int accountId;
  final int productId;
  final int quantity;
  final double totalPrice;
  final String status;
  final String orderDate;
  final String? updatedAt;
  final Product? product;
  final User? account;

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
    this.account,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.tryParse(json['id'].toString()) ?? 0,
      accountId: int.tryParse(json['account_id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      orderDate: json['order_date']?.toString() ?? 
                json['created_at']?.toString() ?? 
                DateTime.now().toIso8601String(),
      updatedAt: json['updated_at']?.toString(),
      product: json['product'] != null 
          ? Product.fromJson(json['product'] is Map ? json['product'] : {}) 
          : null,
      account: json['account'] != null && json['account'] is Map<String, dynamic>
          ? User.fromJson(json['account']) 
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
      'updated_at': updatedAt,
      'product': product?.toJson(), 
      'account': account?.toJson(), 
    };
  }

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

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Order copyWith({
    int? id,
    int? accountId,
    int? productId,
    int? quantity,
    double? totalPrice,
    String? status,
    String? orderDate,
    String? updatedAt,
    Product? product,
    User? account,
  }) {
    return Order(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      updatedAt: updatedAt ?? this.updatedAt,
      product: product ?? this.product,
      account: account ?? this.account,
    );
  }
}