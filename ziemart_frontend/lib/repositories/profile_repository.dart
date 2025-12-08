import '../models/user_model.dart';
import '../services/api_service.dart';

class ProfileRepository {
  final ApiService _api = ApiService();

  // GET Profile
  Future<User?> getProfile(int userId) async {
    try {
      final response = await _api.get("profile/$userId");
      
      if (response["success"] == true && response["data"] != null) {
        return User.fromJson(response["data"]);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // UPDATE Profile
  Future<User?> updateProfile(int userId, Map<String, dynamic> data) async {
    try {
      final response = await _api.put("profile/$userId", data);
      
      if (response["success"] == true && response["data"] != null) {
        final user = User.fromJson(response["data"]);
        
        // Update local storage juga
        await _api.saveUserToLocal(response["data"]);
        
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // CHANGE Password
  Future<bool> changePassword(
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final body = {
        "old_password": oldPassword,
        "new_password": newPassword,
      };
      
      final response = await _api.put("profile/$userId/change-password", body);
      return response["success"] == true;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE Account
  Future<bool> deleteAccount(int userId) async {
    try {
      final response = await _api.delete("profile/$userId");
      
      if (response["success"] == true) {
        // Hapus data local storage
        await _api.logout();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}