import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _api = ApiService();

  // REGISTER
  Future<bool> register(User user, String password) async {
    final body = {
      "username": user.username,
      "email": user.email,
      "password": password,
      "role": user.role,
      "phone_number": user.phoneNumber ?? "",
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

  // LOGIN - Simpan user data ke local storage
  Future<User?> login(String email, String password) async {
    final body = {"email": email, "password": password};

    try {
      final response = await _api.post("login", body);
      
      if (response["success"] == true && response["data"] != null) {
        // Parse user dari response
        final user = User.fromJson(response["data"]);
        
        // Simpan ke local storage
        await _api.saveUserToLocal(response["data"]);
        
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // GET CURRENT USER dari local storage
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _api.getUserFromLocal();
      if (userData != null) {
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // CHECK IF LOGGED IN
  Future<bool> isLoggedIn() async {
    return await _api.isLoggedIn();
  }

  // LOGOUT
  Future<void> logout() async {
    await _api.logout();
  }

  // FORGOT PASSWORD
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final body = {"email": email};

    try {
      final response = await _api.post("forgot-password", body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // VERIFY EMAIL CODE
  Future<bool> verifyEmailCode(String email, String code) async {
    final body = {"email": email, "code": code};

    try {
      final response = await _api.post("verifyCodeEmail", body);
      return response["message"] != null;
    } catch (e) {
      rethrow;
    }
  }
}