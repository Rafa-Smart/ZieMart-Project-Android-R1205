import 'category_model.dart';

// -------------------- Seller Model --------------------
class Seller {
  final int id;
  final String storeName;
  final String phoneNumber;

  Seller({
    required this.id,
    required this.storeName,
    required this.phoneNumber,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: int.tryParse(json['id'].toString()) ?? 0,
      storeName: json['store_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }
}

// -------------------- Product Model --------------------

class Product {
  final int id;
  final String productName;
  final String description;
  final double price; // <-- DIGANTI JADI DOUBLE agar aman
  final int stock;
  final String img;
  final int categoryId;
  final String createdAt;
  final String updatedAt;

  final Category category;
  final Seller? seller;

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    required this.img,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    this.seller,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parsing category
    final category = Category.fromJson(json['category']);

    // Parsing seller (boleh null)
    Seller? seller;
    if (json['seller'] != null) {
      seller = Seller.fromJson(json['seller']);
    }

    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      
      // FIX TERBESAR: Price bisa string/double/int → semuanya aman
      price: double.tryParse(json['price'].toString()) ?? 0.0,

      // Stock juga bisa dikirim sebagai string
      stock: int.tryParse(json['stock'].toString()) ?? 0,

      img: json['img']?.toString() ?? '',
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      category: category,
      seller: seller,
    );
  }
}
