import '../models/cart_model.dart';
import '../services/api_service.dart';

class CartRepository {
  final ApiService _api = ApiService();

  // GET Cart
  Future<CartData?> getCart(int accountId) async {
    try {
      final response = await _api.get("cart/$accountId");
      
      if (response["success"] == true && response["data"] != null) {
        return CartData.fromJson(response["data"]);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // ADD to Cart
  Future<bool> addToCart(int accountId, int productId, int quantity) async {
    try {
      final body = {
        "account_id": accountId.toString(),
        "product_id": productId.toString(),
        "quantity": quantity.toString(),
      };
      
      final response = await _api.post("cart", body);
      return response["success"] == true;
    } catch (e) {
      rethrow;
    }
  }

  // UPDATE Cart Item
  Future<bool> updateCartItem(int cartId, int quantity) async {
    try {
      final body = {"quantity": quantity.toString()};
      final response = await _api.put("cart/$cartId", body);
      return response["success"] == true;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE Cart Item
  Future<bool> removeFromCart(int cartId) async {
    try {
      final response = await _api.delete("cart/$cartId");
      return response["success"] == true;
    } catch (e) {
      rethrow;
    }
  }

  // CLEAR Cart
  Future<bool> clearCart(int accountId) async {
    try {
      final response = await _api.delete("cart/clear/$accountId");
      return response["success"] == true;
    } catch (e) {
      rethrow;
    }
  }

  // GET Cart Count
  Future<int> getCartCount(int accountId) async {
    try {
      final response = await _api.get("cart/count/$accountId");
      
      if (response["success"] == true) {
        return response["count"] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}