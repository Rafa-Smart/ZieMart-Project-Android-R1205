import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? role = "buyer";

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final extraController = TextEditingController();

  Future<bool> register() async {
    // Validasi password matching
    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = "Password tidak sama";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = User(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      role: role ?? "buyer",
      phoneNumber: phoneController.text.trim(),
      fullName: role == "buyer" ? extraController.text.trim() : null,
      storeName: role == "seller" ? extraController.text.trim() : null,
    );

    try {
      final success = await _repository.register(user, passwordController.text);
      
      if (!success) {
        _errorMessage = "Registrasi gagal. Username atau email mungkin sudah digunakan.";
      }
      
      return success;
    } catch (e) {
      debugPrint("Error Register: $e");
      _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeRole(String? newRole) {
    role = newRole;
    extraController.clear();
    notifyListeners();
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    extraController.dispose();
    super.dispose();
  }
}