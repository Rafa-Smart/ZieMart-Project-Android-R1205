import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Inisialisasi - cek apakah user sudah login sebelumnya
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _repository.isLoggedIn();
      if (_isLoggedIn) {
        _currentUser = await _repository.getCurrentUser();
      }
    } catch (e) {
      debugPrint("Error initializing auth: $e");
      _isLoggedIn = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      final user = await _repository.login(email, password);
      
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Update user data (misal setelah update profile)
  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Helper getters
  String? get userId => _currentUser?.id.toString();
  String? get userEmail => _currentUser?.email;
  String? get userName => _currentUser?.username;
  String? get userRole => _currentUser?.role;
  bool get isBuyer => _currentUser?.role == 'buyer';
  bool get isSeller => _currentUser?.role == 'seller';
}