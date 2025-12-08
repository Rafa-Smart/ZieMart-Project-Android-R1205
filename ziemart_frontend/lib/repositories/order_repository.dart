import '../services/api_service.dart';
import '../models/order_model.dart';

class OrderRepository {
  final ApiService _api = ApiService();

  // Get all orders for a user
  Future<List<Order>> getOrders(int accountId) async {
    try {
      final response = await _api.get("orders/$accountId");
      final List<dynamic> ordersJson = response['data'];
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get order by ID
  Future<Order> getOrderById(int orderId) async {
    try {
      final response = await _api.get("orders/detail/$orderId");
      return Order.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Create new order
  Future<Order> createOrder({
    required int accountId,
    required int productId,
    required int quantity,
    required double totalPrice,
  }) async {
    try {
      final response = await _api.post("orders", {
        'account_id': accountId.toString(),
        'product_id': productId.toString(),
        'quantity': quantity.toString(),
        'total_price': totalPrice.toString(),
      });
      return Order.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Update order status
  Future<Order> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await _api.put("orders/$orderId", {
        'status': status,
      });
      return Order.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel order
  Future<void> cancelOrder(int orderId) async {
    try {
      await _api.put("orders/$orderId", {
        'status': 'cancelled',
      });
    } catch (e) {
      rethrow;
    }
  }
}