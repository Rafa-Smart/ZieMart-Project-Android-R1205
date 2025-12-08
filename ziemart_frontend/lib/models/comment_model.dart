class Comment {
  final int? id;
  final int accountId;
  final int productId;
  final String commentText;
  final String? createdAt;
  final String? updatedAt;
  final String? timeAgo; // BARU: untuk "3 menit yang lalu"
  final Account? account; // BARU: untuk nama user

  Comment({
    this.id,
    required this.accountId,
    required this.productId,
    required this.commentText,
    this.createdAt,
    this.updatedAt,
    this.timeAgo,
    this.account,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: int.tryParse(json['id'].toString()),
      accountId: int.tryParse(json['account_id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      commentText: json['comment_text']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      timeAgo: json['time_ago']?.toString() ?? 'Baru saja',
      account: json['account'] != null 
          ? Account.fromJson(json['account']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'product_id': productId,
      'comment_text': commentText,
    };
  }
}

// Model untuk Account dalam Comment
class Account {
  final int id;
  final String username;
  final String? email;

  Account({
    required this.id,
    required this.username,
    this.email,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: int.tryParse(json['id'].toString()) ?? 0,
      username: json['username']?.toString() ?? 'User',
      email: json['email']?.toString(),
    );
  }
}