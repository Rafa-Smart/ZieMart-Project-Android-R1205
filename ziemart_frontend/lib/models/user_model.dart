class User {
  final int? id;
  final String username;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? fullName;
  final String? storeName;
  final String? profilePicture;
  final String? password;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.fullName,
    this.storeName,
    this.profilePicture,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id']?.toString() ?? ''),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'buyer',
      phoneNumber: json['phone_number']?.toString(),
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString(),
      storeName: json['store_name']?.toString() ?? json['storeName']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      password: json['password']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'store_name': storeName,
      'profile_picture': profilePicture,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    String? phoneNumber,
    String? fullName,
    String? storeName,
    String? profilePicture,
    String? password,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      storeName: storeName ?? this.storeName,
      profilePicture: profilePicture ?? this.profilePicture,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}