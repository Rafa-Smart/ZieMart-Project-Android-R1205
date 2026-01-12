import '../services/api_service.dart';
import '../models/wishlist_model.dart';

class WishlistRepository {
  final ApiService _api = ApiService();

 
  Future<List<Wishlist>> getWishlist(int accountId) async {
    try {
      final response = await _api.get("wishlist/$accountId");
      final List<dynamic> wishlistJson = response['data'];
      return wishlistJson.map((json) => Wishlist.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }


  Future<Wishlist> addToWishlist(int accountId, int productId) async {
    try {
      final response = await _api.post("wishlist", {
        'account_id': accountId.toString(),
        'product_id': productId.toString(),
      });
      return Wishlist.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromWishlist(int wishlistId) async {
    try {
      await _api.delete("wishlist/$wishlistId");
    } catch (e) {
      rethrow;
    }
  }


  Future<bool> checkWishlist(int accountId, int productId) async {
    try {
      final response = await _api.post("wishlist/check", {
        'account_id': accountId.toString(),
        'product_id': productId.toString(),
      });
      return response['is_wishlisted'] ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getWishlistCount(int accountId) async {
    try {
      final response = await _api.get("wishlist/count/$accountId");
      return response['count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }


  Future<void> clearWishlist(int accountId) async {
    try {
      await _api.delete("wishlist/clear/$accountId");
    } catch (e) {
      rethrow;
    }
  }
}