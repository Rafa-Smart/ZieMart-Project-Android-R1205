import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderRepository {
  final ApiService _api = ApiService();

  // Get all orders
  Future<List<Order>> getOrders(int accountId) async {
    try {
      final response = await _api.get("orders/$accountId");
      
      if (response["data"] != null) {
        return (response["data"] as List)
            .map((json) => Order.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(int orderId) async {
    try {
      final response = await _api.get("orders/detail/$orderId");
      
      if (response["data"] != null) {
        return Order.fromJson(response["data"]);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Create order
  Future<Order> createOrder({
    required int accountId,
    required int productId,
    required int quantity,
    required double totalPrice,
  }) async {
    try {
      final body = {
        "account_id": accountId.toString(),
        "product_id": productId.toString(),
        "quantity": quantity.toString(),
        "total_price": totalPrice.toString(),
      };
      
      final response = await _api.post("orders", body);
      
      if (response["data"] != null) {
        return Order.fromJson(response["data"]);
      }
      throw Exception("Failed to create order");
    } catch (e) {
      rethrow;
    }
  }

  // Update order status
  Future<Order> updateOrderStatus(int orderId, String status) async {
    try {
      final body = {"status": status};
      final response = await _api.put("orders/$orderId", body);
      
      if (response["data"] != null) {
        return Order.fromJson(response["data"]);
      }
      throw Exception("Failed to update order status");
    } catch (e) {
      rethrow;
    }
  }

  // Cancel order
  Future<void> cancelOrder(int orderId) async {
    try {
      await _api.delete("orders/cancel/$orderId");
    } catch (e) {
      rethrow;
    }
  }

  // Get order statistics
  Future<Map<String, int>> getOrderStatistics(int accountId) async {
    try {
      final response = await _api.get("orders/statistics/$accountId");
      
      if (response["data"] != null) {
        final data = response["data"];
        return {
          'total_orders': data['total_orders'] ?? 0,
          'pending': data['pending'] ?? 0,
          'processing': data['processing'] ?? 0,
          'shipped': data['shipped'] ?? 0,
          'delivered': data['delivered'] ?? 0,
          'cancelled': data['cancelled'] ?? 0,
        };
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }
}