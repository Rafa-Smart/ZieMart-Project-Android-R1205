import 'product_model.dart';

class Wishlist {
  final int id;
  final int accountId;
  final int productId;
  final String createdAt;
  final String updatedAt;
  final Product? product;

  Wishlist({
    required this.id,
    required this.accountId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: int.tryParse(json['id'].toString()) ?? 0,
      accountId: int.tryParse(json['account_id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}