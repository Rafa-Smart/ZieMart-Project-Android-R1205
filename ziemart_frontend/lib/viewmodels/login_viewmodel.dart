import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showError = false;
  bool get showError => _showError;

  bool _isResetLoading = false;
  bool get isResetLoading => _isResetLoading;

  // 🔹 LOGIN
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError = true;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _showError = false;
    notifyListeners();

    try {
      // salahnya disini, inget
      final response = await _repository.login(email, password);

      if (response["success"] == true) {
        return true;
      } else {
        _showError = true;
        return false;
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      _showError = true;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 FORGOT PASSWORD
  Future<bool> sendForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      debugPrint("Email kosong, tidak bisa kirim reset password.");
      return false;
    }

    _isResetLoading = true;
    notifyListeners();

    try {
      final response = await _repository.forgotPassword(email);
      return response["success"] == true;
    } catch (e) {
      debugPrint("Forgot Password Error: $e");
      return false;
    } finally {
      _isResetLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
