<?php

namespace App\Http\Controllers;

use App\Models\Wishlist;
use Illuminate\Http\Request;

class WishlistController extends Controller
{
    // Get all wishlist items for a user
    public function getWishlist($accountId)
    {
        $wishlist = Wishlist::where('account_id', $accountId)
            ->with(['product.category', 'product.seller'])
            ->latest()
            ->get();

        return response()->json([
            'data' => $wishlist,
        ], 200);
    }

    // Add product to wishlist
    public function addToWishlist(Request $request)
    {
        $request->validate([
            'account_id' => 'required|integer|exists:accounts,id',
            'product_id' => 'required|integer|exists:products,id',
        ]);

        // Check if already exists
        $exists = Wishlist::where('account_id', $request->account_id)
            ->where('product_id', $request->product_id)
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Product already in wishlist',
            ], 409);
        }

        $wishlist = Wishlist::create([
            'account_id' => $request->account_id,
            'product_id' => $request->product_id,
        ]);

        // Load relations
        $wishlist->load(['product.category', 'product.seller']);

        return response()->json([
            'message' => 'Product added to wishlist',
            'data' => $wishlist,
        ], 201);
    }

    // Remove product from wishlist
    public function removeFromWishlist($wishlistId)
    {
        $wishlist = Wishlist::find($wishlistId);

        if (!$wishlist) {
            return response()->json([
                'message' => 'Wishlist item not found',
            ], 404);
        }

        $wishlist->delete();

        return response()->json([
            'message' => 'Product removed from wishlist',
        ], 200);
    }

    // Check if product is in wishlist
    public function checkWishlist(Request $request)
    {
        $request->validate([
            'account_id' => 'required|integer',
            'product_id' => 'required|integer',
        ]);

        $exists = Wishlist::where('account_id', $request->account_id)
            ->where('product_id', $request->product_id)
            ->exists();

        return response()->json([
            'is_wishlisted' => $exists,
        ], 200);
    }

    // Get wishlist count
    public function getWishlistCount($accountId)
    {
        $count = Wishlist::where('account_id', $accountId)->count();

        return response()->json([
            'count' => $count,
        ], 200);
    }

    // Clear all wishlist
    public function clearWishlist($accountId)
    {
        Wishlist::where('account_id', $accountId)->delete();

        return response()->json([
            'message' => 'Wishlist cleared',
        ], 200);
    }
}