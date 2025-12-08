import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _currentUser;
  User? get currentUser => _currentUser;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final extraController = TextEditingController(); // full_name atau store_name

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // LOAD Profile
  Future<void> loadProfile(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.getProfile(userId);
      
      if (user != null) {
        _currentUser = user;
        
        // Isi controllers dengan data user
        usernameController.text = user.username;
        emailController.text = user.email;
        phoneController.text = user.phoneNumber ?? '';
        
        if (user.role == 'buyer') {
          extraController.text = user.fullName ?? '';
        } else {
          extraController.text = user.storeName ?? '';
        }
      } else {
        _errorMessage = "Gagal memuat profile";
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      _errorMessage = "Terjadi kesalahan: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE Profile
  Future<bool> updateProfile() async {
    if (_currentUser == null) {
      _errorMessage = "User tidak ditemukan";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = {
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "phone_number": phoneController.text.trim(),
      };

      // Tambahkan field sesuai role
      if (_currentUser!.role == 'buyer') {
        data["full_name"] = extraController.text.trim();
      } else {
        data["store_name"] = extraController.text.trim();
      }

      final updatedUser = await _repository.updateProfile(_currentUser!.id!, data);
      
      if (updatedUser != null) {
        _currentUser = updatedUser;
        return true;
      } else {
        _errorMessage = "Gagal update profile";
        return false;
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CHANGE Password
  Future<bool> changePassword() async {
    if (_currentUser == null) {
      _errorMessage = "User tidak ditemukan";
      notifyListeners();
      return false;
    }

    // Validasi
    if (oldPasswordController.text.isEmpty || 
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _errorMessage = "Semua field password wajib diisi";
      notifyListeners();
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _errorMessage = "Password baru tidak sama";
      notifyListeners();
      return false;
    }

    if (newPasswordController.text.length < 6) {
      _errorMessage = "Password minimal 6 karakter";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.changePassword(
        _currentUser!.id!,
        oldPasswordController.text,
        newPasswordController.text,
      );

      if (success) {
        // Clear password fields
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        return true;
      } else {
        _errorMessage = "Gagal mengubah password";
        return false;
      }
    } catch (e) {
      debugPrint("Error changing password: $e");
      
      // Parse error message
      if (e.toString().contains('400')) {
        _errorMessage = "Password lama salah";
      } else {
        _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE Account
  Future<bool> deleteAccount() async {
    if (_currentUser == null) {
      _errorMessage = "User tidak ditemukan";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.deleteAccount(_currentUser!.id!);
      return success;
    } catch (e) {
      debugPrint("Error deleting account: $e");
      _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    extraController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}