<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\BuyerController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\HelpController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\WishlistController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// ========== AUTHENTICATION ==========
Route::post('ziemart/register', [AccountController::class, 'store']);
Route::post('ziemart/verifyCodeEmail', [AccountController::class, 'verifyCode']);
Route::post('ziemart/login', [AuthController::class, 'login']);
Route::post('ziemart/forgot-password', [AuthController::class, 'forgotPassword']);

// ========== ACCOUNT MANAGEMENT ==========
Route::get('ziemart/read', [AccountController::class, 'index']);
Route::put('ziemart/update/{id}', [AccountController::class, 'update']);
Route::delete('ziemart/delete/{id}', [AccountController::class, 'destroy']);

// ========== PROFILE ==========
Route::get('ziemart/profile/{id}', [ProfileController::class, 'getProfile']);
Route::put('ziemart/profile/{id}', [ProfileController::class, 'updateProfile']);
Route::put('ziemart/profile/{id}/change-password', [ProfileController::class, 'changePassword']);
Route::delete('ziemart/profile/{id}', [ProfileController::class, 'deleteAccount']);

// ========== CATEGORIES (NEW) ==========
Route::get('ziemart/categories', [CategoryController::class, 'getCategories']);
Route::get('ziemart/categories/{id}', [CategoryController::class, 'getCategoryById']);
Route::get('ziemart/categories/{id}/products', [CategoryController::class, 'getProductsByCategory']);
Route::get('ziemart/categories/popular/list', [CategoryController::class, 'getPopularCategories']);

// ========== PRODUCTS ==========
Route::get('ziemart/getProducts', [ProductController::class, 'getProduct']);
Route::get('ziemart/getProducts/{id}', [ProductController::class, 'getProductById']);
Route::get('ziemart/searchProducts', [ProductController::class, 'searchProduct']);

// ========== COMMENTS ==========
Route::get('ziemart/comments/{productId}', [CommentController::class, 'getComments']);
Route::post('ziemart/comments/{productId}', [CommentController::class, 'addComment']);

// ========== CART ==========
Route::get('ziemart/cart/{accountId}', [CartController::class, 'getCart']);
Route::post('ziemart/cart', [CartController::class, 'addToCart']);
Route::put('ziemart/cart/{cartId}', [CartController::class, 'updateCart']);
Route::delete('ziemart/cart/{cartId}', [CartController::class, 'removeFromCart']);
Route::delete('ziemart/cart/clear/{accountId}', [CartController::class, 'clearCart']);
Route::get('ziemart/cart/count/{accountId}', [CartController::class, 'getCartCount']);

// ========== WISHLIST ==========
Route::get('ziemart/wishlist/{accountId}', [WishlistController::class, 'getWishlist']);
Route::post('ziemart/wishlist', [WishlistController::class, 'addToWishlist']);
Route::delete('ziemart/wishlist/{wishlistId}', [WishlistController::class, 'removeFromWishlist']);
Route::post('ziemart/wishlist/check', [WishlistController::class, 'checkWishlist']);
Route::get('ziemart/wishlist/count/{accountId}', [WishlistController::class, 'getWishlistCount']);
Route::delete('ziemart/wishlist/clear/{accountId}', [WishlistController::class, 'clearWishlist']);

// ========== ORDERS ==========
Route::get('ziemart/orders/{accountId}', [OrderController::class, 'getOrders']);
Route::get('ziemart/orders/detail/{orderId}', [OrderController::class, 'getOrderById']);
Route::post('ziemart/orders', [OrderController::class, 'createOrder']);
Route::put('ziemart/orders/{orderId}', [OrderController::class, 'updateOrderStatus']);
Route::delete('ziemart/orders/cancel/{orderId}', [OrderController::class, 'cancelOrder']);
Route::get('ziemart/orders/statistics/{accountId}', [OrderController::class, 'getOrderStatistics']);
Route::post('ziemart/send-help-email', [HelpController::class, 'sendHelpEmail']);
// ========== TEST ==========
Route::get('/test', function () {
    return response()->json(['message' => 'API is working']);
});