import 'category_model.dart'; 

class Product {
  final int id;
  final String productName;
  final String description;
  final int price;
  final int stock;
  final String img;
  final int categoryId;
  final String createdAt;
  final String updatedAt;
  final Category category; 

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
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parsing data Category terlebih dahulu
    final categoryJson = json['category'] as Map<String, dynamic>;
    final category = Category.fromJson(categoryJson);
    
    // Parsing data Product
    return Product(
      id: json['id'] as int,
      productName: json['product_name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
      img: json['img'] as String,
      categoryId: json['category_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      category: category,
    );
  }
}