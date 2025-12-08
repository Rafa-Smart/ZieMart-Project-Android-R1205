<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\Product;
use Illuminate\Http\Request;

class CartController extends Controller
{
    // GET: Ambil semua item di keranjang user
    public function getCart($accountId)
    {
        $cartItems = Cart::where('account_id', $accountId)
            ->with(['product.category', 'product.seller'])
            ->get();

        $formattedItems = $cartItems->map(function ($item) {
            return [
                'id' => $item->id,
                'product_id' => $item->product_id,
                'product_name' => $item->product->product_name,
                'product_image' => $item->product->img,
                'price' => $item->product->price,
                'quantity' => $item->quantity,
                'subtotal' => $item->product->price * $item->quantity,
                'seller_phone' => $item->product->seller->phone_number ?? null,
                'seller_name' => $item->product->seller->store_name ?? null,
            ];
        });

        $total = $formattedItems->sum('subtotal');

        return response()->json([
            'success' => true,
            'data' => [
                'items' => $formattedItems,
                'total' => $total,
                'item_count' => $cartItems->count(),
            ],
        ], 200);
    }

    // POST: Tambah item ke keranjang
    public function addToCart(Request $request)
    {
        $request->validate([
            'account_id' => 'required|exists:accounts,id',
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
        ]);

        // Cek apakah produk sudah ada di keranjang
        $existingCart = Cart::where('account_id', $request->account_id)
            ->where('product_id', $request->product_id)
            ->first();

        if ($existingCart) {
            // Update quantity
            $existingCart->quantity += $request->quantity;
            $existingCart->save();

            return response()->json([
                'success' => true,
                'message' => 'Jumlah produk di keranjang berhasil diupdate.',
                'data' => $existingCart,
            ], 200);
        }

        // Tambah item baru
        $cart = Cart::create([
            'account_id' => $request->account_id,
            'product_id' => $request->product_id,
            'quantity' => $request->quantity,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Produk berhasil ditambahkan ke keranjang.',
            'data' => $cart,
        ], 201);
    }

    // PUT: Update quantity item di keranjang
    public function updateCart(Request $request, $cartId)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $cart = Cart::find($cartId);

        if (!$cart) {
            return response()->json([
                'success' => false,
                'message' => 'Item tidak ditemukan.',
            ], 404);
        }

        $cart->quantity = $request->quantity;
        $cart->save();

        return response()->json([
            'success' => true,
            'message' => 'Jumlah produk berhasil diupdate.',
            'data' => $cart,
        ], 200);
    }

    // DELETE: Hapus item dari keranjang
    public function removeFromCart($cartId)
    {
        $cart = Cart::find($cartId);

        if (!$cart) {
            return response()->json([
                'success' => false,
                'message' => 'Item tidak ditemukan.',
            ], 404);
        }

        $cart->delete();

        return response()->json([
            'success' => true,
            'message' => 'Produk berhasil dihapus dari keranjang.',
        ], 200);
    }

    // DELETE: Hapus semua item di keranjang user
    public function clearCart($accountId)
    {
        Cart::where('account_id', $accountId)->delete();

        return response()->json([
            'success' => true,
            'message' => 'Keranjang berhasil dikosongkan.',
        ], 200);
    }

    // GET: Hitung jumlah item di keranjang
    public function getCartCount($accountId)
    {
        $count = Cart::where('account_id', $accountId)->count();

        return response()->json([
            'success' => true,
            'count' => $count,
        ], 200);
    }
}