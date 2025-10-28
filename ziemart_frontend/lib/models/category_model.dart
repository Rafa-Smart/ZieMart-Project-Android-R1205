class Category {
  final int id;
  final String categoryName;
  final String description;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.createdAt,
    required this.updatedAt
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      categoryName: json['category_name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}