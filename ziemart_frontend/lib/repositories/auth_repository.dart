import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _api = ApiService();
  Future<bool> register(User user, String password) async {
    final body = {
      "username": user.username,
      "email": user.email,
      "password": password,
      "role": user.role,
      "phone_number": user.phoneNumber,
      "fullName": user.fullName ?? "",
      "store_name": user.storeName ?? "",
    };

    try {
      final response = await _api.post("register", body);
      return response["success"] == true || response["status"] == "ok";
    } catch (e) {
      rethrow;
    }
  }

  // 🔹 LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    final body = {"email": email, "password": password};

    try {
      final response = await _api.post("login", body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // 🔹 FORGOT PASSWORD
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final body = {"email": email};

    try {
      final response = await _api.post("forgot-password", body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
