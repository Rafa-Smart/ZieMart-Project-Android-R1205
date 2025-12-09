class Category {
  final int id;
  final String categoryName;
  final String? description;
  final String? icon;
  final String? color;
  final int? productsCount;

  Category({
    required this.id,
    required this.categoryName,
    this.description,
    this.icon,
    this.color,
    this.productsCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      categoryName: json['category_name']?.toString() ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
      color: json['color']?.toString(),
      productsCount: json['products_count'] != null 
          ? int.tryParse(json['products_count'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'description': description,
      'icon': icon,
      'color': color,
      'products_count': productsCount,
    };
  }
}