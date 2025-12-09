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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'phone_number': phoneNumber,
    };
  }
}

// -------------------- Product Model --------------------
class Product {
  final int id;
  final String productName;
  final String description;
  final double price;
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
    Category category;
    if (json['category'] != null) {
      if (json['category'] is Map<String, dynamic>) {
        category = Category.fromJson(json['category']);
      } else {
        category = Category(
          id: int.tryParse(json['category_id'].toString()) ?? 0,
          categoryName: '',
        );
      }
    } else {
      category = Category(
        id: int.tryParse(json['category_id'].toString()) ?? 0,
        categoryName: '',
      );
    }

    // Parsing seller
    Seller? seller;
    if (json['seller'] != null && json['seller'] is Map<String, dynamic>) {
      seller = Seller.fromJson(json['seller']);
    }

    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      img: json['img']?.toString() ?? '',
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      category: category,
      seller: seller,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'description': description,
      'price': price,
      'stock': stock,
      'img': img,
      'category_id': categoryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category.toJson(),
      'seller': seller?.toJson(),
    };
  }
}