class Comment {
  final int? id;
  final int accountId;
  final int productId;
  final String commentText;
  final String? createdAt;
  final String? updatedAt;

  Comment({
    this.id,
    required this.accountId,
    required this.productId,
    required this.commentText,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: int.parse(json['id'].toString()),
      accountId: int.parse(json['account_id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      commentText: json['comment_text'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
