<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    // Get all orders for a user
    public function getOrders($accountId)
    {
        $orders = Order::where('account_id', $accountId)
            ->with(['product.category', 'product.seller'])
            ->latest()
            ->get();

        return response()->json([
            'data' => $orders,
        ], 200);
    }

    // Get order by ID
    public function getOrderById($orderId)
    {
        $order = Order::with(['product.category', 'product.seller', 'account'])
            ->find($orderId);

        if (!$order) {
            return response()->json([
                'message' => 'Order not found',
            ], 404);
        }

        return response()->json([
            'data' => $order,
        ], 200);
    }

    // Create new order
    public function createOrder(Request $request)
    {
        $request->validate([
            'account_id' => 'required|integer|exists:accounts,id',
            'product_id' => 'required|integer|exists:products,id',
            'quantity' => 'required|integer|min:1',
            'total_price' => 'required|numeric|min:0',
        ]);

        $order = Order::create([
            'account_id' => $request->account_id,
            'product_id' => $request->product_id,
            'quantity' => $request->quantity,
            'total_price' => $request->total_price,
            'status' => 'pending',
            'order_date' => now(),
        ]);

        // Load relations
        $order->load(['product.category', 'product.seller']);

        return response()->json([
            'message' => 'Order created successfully',
            'data' => $order,
        ], 201);
    }

    // Update order status
    public function updateOrderStatus(Request $request, $orderId)
    {
        $order = Order::find($orderId);

        if (!$order) {
            return response()->json([
                'message' => 'Order not found',
            ], 404);
        }

        $request->validate([
            'status' => 'required|in:pending,processing,shipped,delivered,cancelled',
        ]);

        $order->update([
            'status' => $request->status,
        ]);

        // Load relations
        $order->load(['product.category', 'product.seller']);

        return response()->json([
            'message' => 'Order status updated successfully',
            'data' => $order,
        ], 200);
    }

    // Cancel order
    public function cancelOrder($orderId)
    {
        $order = Order::find($orderId);

        if (!$order) {
            return response()->json([
                'message' => 'Order not found',
            ], 404);
        }

        if ($order->status !== 'pending') {
            return response()->json([
                'message' => 'Only pending orders can be cancelled',
            ], 400);
        }

        $order->update([
            'status' => 'cancelled',
        ]);

        return response()->json([
            'message' => 'Order cancelled successfully',
            'data' => $order,
        ], 200);
    }

    // Get order statistics
    public function getOrderStatistics($accountId)
    {
        $statistics = [
            'total_orders' => Order::where('account_id', $accountId)->count(),
            'pending' => Order::where('account_id', $accountId)->byStatus('pending')->count(),
            'processing' => Order::where('account_id', $accountId)->byStatus('processing')->count(),
            'shipped' => Order::where('account_id', $accountId)->byStatus('shipped')->count(),
            'delivered' => Order::where('account_id', $accountId)->byStatus('delivered')->count(),
            'cancelled' => Order::where('account_id', $accountId)->byStatus('cancelled')->count(),
        ];

        return response()->json([
            'data' => $statistics,
        ], 200);
    }
}