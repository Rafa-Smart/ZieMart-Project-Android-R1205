import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _repository = CartRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CartData? _cartData;
  CartData? get cartData => _cartData;

  List<CartItem> get cartItems => _cartData?.items ?? [];
  double get totalPrice => _cartData?.total ?? 0;
  int get itemCount => _cartData?.itemCount ?? 0;

  // LOAD Cart
  Future<void> loadCart(int accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cartData = await _repository.getCart(accountId);
    } catch (e) {
      debugPrint("Error loading cart: $e");
      _errorMessage = "Gagal memuat keranjang";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ADD to Cart
  Future<bool> addToCart(int accountId, int productId, int quantity) async {
    try {
      final success = await _repository.addToCart(accountId, productId, quantity);
      
      if (success) {
        // Reload cart
        await loadCart(accountId);
      }
      
      return success;
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      _errorMessage = "Gagal menambahkan ke keranjang";
      notifyListeners();
      return false;
    }
  }

  // UPDATE Cart Item
  Future<bool> updateCartItem(int accountId, int cartId, int quantity) async {
    try {
      final success = await _repository.updateCartItem(cartId, quantity);
      
      if (success) {
        await loadCart(accountId);
      }
      
      return success;
    } catch (e) {
      debugPrint("Error updating cart: $e");
      _errorMessage = "Gagal mengupdate keranjang";
      notifyListeners();
      return false;
    }
  }

  // REMOVE from Cart
  Future<bool> removeFromCart(int accountId, int cartId) async {
    try {
      final success = await _repository.removeFromCart(cartId);
      
      if (success) {
        await loadCart(accountId);
      }
      
      return success;
    } catch (e) {
      debugPrint("Error removing from cart: $e");
      _errorMessage = "Gagal menghapus dari keranjang";
      notifyListeners();
      return false;
    }
  }

  // CLEAR Cart
  Future<bool> clearCart(int accountId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.clearCart(accountId);
      
      if (success) {
        _cartData = null;
      }
      
      return success;
    } catch (e) {
      debugPrint("Error clearing cart: $e");
      _errorMessage = "Gagal mengosongkan keranjang";
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
}