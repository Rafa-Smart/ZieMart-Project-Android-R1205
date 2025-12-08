class User {
  final int? id;
  final String username;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? fullName;
  final String? storeName;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.fullName,
    this.storeName,
  });

  // Dari JSON (response API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'buyer',
      phoneNumber: json['phone_number'],
      fullName: json['full_name'] ?? json['fullName'],
      storeName: json['store_name'] ?? json['storeName'],
    );
  }

  // Ke JSON (untuk simpan di local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'store_name': storeName,
    };
  }
}