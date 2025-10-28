<?php

use App\Models\User;
use Inertia\Inertia;
use App\Models\Account;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\AccountController;

Route::get('/', function () {
    return Inertia::render('welcome');
})->name('home');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('dashboard', function () {
        return Inertia::render('dashboard');
    })->name('dashboard');
});

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';


Route::get("/arsa", [UserController::class, 'index']);
Route::get("/testing", [UserController::class, 'index']);


use App\Http\Controllers\EmailController;

Route::get('/send-email', [EmailController::class, 'index'])->name('email.form');
Route::post('/send-email', [EmailController::class, 'send'])->name('email.send');
