import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();

  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load orders
  Future<void> loadOrders(int accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _repository.getOrders(accountId);
      _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate)); // Sort by newest
    } catch (e) {
      _errorMessage = e.toString();
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(int orderId) async {
    try {
      return await _repository.getOrderById(orderId);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  // Create order
  Future<bool> createOrder({
    required int accountId,
    required int productId,
    required int quantity,
    required double totalPrice,
  }) async {
    try {
      final order = await _repository.createOrder(
        accountId: accountId,
        productId: productId,
        quantity: quantity,
        totalPrice: totalPrice,
      );
      _orders.insert(0, order);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      final updatedOrder = await _repository.updateOrderStatus(orderId, status);
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId) async {
    try {
      await _repository.cancelOrder(orderId);
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = Order(
          id: _orders[index].id,
          accountId: _orders[index].accountId,
          productId: _orders[index].productId,
          quantity: _orders[index].quantity,
          totalPrice: _orders[index].totalPrice,
          status: 'cancelled',
          orderDate: _orders[index].orderDate,
          updatedAt: DateTime.now().toString(),
          product: _orders[index].product,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Filter orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Get order count
  int get orderCount => _orders.length;
}