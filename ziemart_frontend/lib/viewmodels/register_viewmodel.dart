import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? role = "buyer";

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final extraController = TextEditingController();

  Future<bool> register() async {
    _isLoading = true;
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
      return success;
    } catch (e) {
      debugPrint("Error Register: $e");
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