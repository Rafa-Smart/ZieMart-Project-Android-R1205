import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isResetLoading = false;
  bool get isResetLoading => _isResetLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _currentUser;
  User? get currentUser => _currentUser;

  // LOGIN
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Email dan password wajib diisi";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(email, password);

      if (user != null) {
        _currentUser = user;
        return true;
      } else {
        _errorMessage = "Email atau password salah";
        return false;
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      _errorMessage = "Terjadi kesalahan. Silakan coba lagi.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CHECK IF USER ALREADY LOGGED IN
  Future<bool> checkLoginStatus() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _repository.getCurrentUser();
        notifyListeners();
      }
      return isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  // GET CURRENT USER
  Future<User?> loadCurrentUser() async {
    try {
      _currentUser = await _repository.getCurrentUser();
      notifyListeners();
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
  }

  // FORGOT PASSWORD
  Future<bool> sendForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _errorMessage = "Email wajib diisi untuk reset password";
      notifyListeners();
      return false;
    }

    _isResetLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.forgotPassword(email);
      return response["success"] == true;
    } catch (e) {
      debugPrint("Forgot Password Error: $e");
      _errorMessage = "Gagal mengirim email reset password";
      return false;
    } finally {
      _isResetLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}