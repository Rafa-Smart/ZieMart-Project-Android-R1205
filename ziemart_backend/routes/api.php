<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BuyerController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\ProductController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


Route::post('ziemart/register', [AccountController::class, 'store']);
Route::post('ziemart/verifyCodeEmail', [AccountController::class, 'verifyCode']);
Route::get('ziemart/read', [AccountController::class, 'index']);
Route::put('ziemart/update/{id}', [AccountController::class, 'update']);
Route::delete('ziemart/delete/{id}', [AccountController::class, 'destroy']);
Route::post('ziemart/login', [AuthController::class, 'login']);
Route::post('ziemart/forgot-password', [AuthController::class, 'forgotPassword']);
Route::get('/test', function () {
    return response()->json(['message' => 'API is working']);
});


// get product

Route::get('ziemart/getProducts', [ProductController::class, 'getProduct']);
Route::get('ziemart/getProducts/{id}', [ProductController::class, 'getProductById']);

Route::get('/ziemart/searchProducts', [ProductController::class, 'searchProduct']);

Route::get('ziemart/comments/{productId}', [CommentController::class, 'getComments']);
Route::post('ziemart/comments/{productId}', [CommentController::class, 'addComment']);


