import 'package:flutter/foundation.dart';
import '../models/wishlist_model.dart';
import '../repositories/wishlist_repository.dart';

class WishlistViewModel extends ChangeNotifier {
  final WishlistRepository _repository = WishlistRepository();

  List<Wishlist> _wishlists = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _itemCount = 0;

  List<Wishlist> get wishlists => _wishlists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _itemCount;

  // Load wishlist
  Future<void> loadWishlist(int accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wishlists = await _repository.getWishlist(accountId);
      _itemCount = _wishlists.length;
    } catch (e) {
      _errorMessage = e.toString();
      _wishlists = [];
      _itemCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to wishlist
  Future<bool> addToWishlist(int accountId, int productId) async {
    try {
      final wishlist = await _repository.addToWishlist(accountId, productId);
      _wishlists.insert(0, wishlist);
      _itemCount = _wishlists.length;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Remove from wishlist
  Future<bool> removeFromWishlist(int wishlistId) async {
    try {
      await _repository.removeFromWishlist(wishlistId);
      _wishlists.removeWhere((w) => w.id == wishlistId);
      _itemCount = _wishlists.length;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Check if product is in wishlist
  Future<bool> checkWishlist(int accountId, int productId) async {
    try {
      return await _repository.checkWishlist(accountId, productId);
    } catch (e) {
      return false;
    }
  }

  // Get wishlist count
  Future<void> loadWishlistCount(int accountId) async {
    try {
      _itemCount = await _repository.getWishlistCount(accountId);
      notifyListeners();
    } catch (e) {
      _itemCount = 0;
    }
  }

  // Clear all wishlist
  Future<bool> clearWishlist(int accountId) async {
    try {
      await _repository.clearWishlist(accountId);
      _wishlists.clear();
      _itemCount = 0;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Check if specific product is wishlisted (local check)
  bool isProductWishlisted(int productId) {
    return _wishlists.any((w) => w.productId == productId);
  }

  // Get wishlist ID by product ID
  int? getWishlistIdByProductId(int productId) {
    try {
      return _wishlists.firstWhere((w) => w.productId == productId).id;
    } catch (e) {
      return null;
    }
  }
}