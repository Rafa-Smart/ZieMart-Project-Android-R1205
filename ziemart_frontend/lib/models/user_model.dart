class User {
  final String username;
  final String email;
  final String role;
  final String phoneNumber;
  final String? fullName;
  final String? storeName;

  User({
    required this.username,
    required this.email,
    required this.role,
    required this.phoneNumber,
    this.fullName,
    this.storeName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullName: json['fullName'],
      storeName: json['storeName'],
    );
  }
}