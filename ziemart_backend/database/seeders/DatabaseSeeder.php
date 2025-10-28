<?php

namespace Database\Seeders;

use App\Models\Account;
use App\Models\Admin;
use App\Models\Buyer;
use App\Models\Category;
use App\Models\ClassModel;
use App\Models\Order;
use App\Models\OrderDetail;
use App\Models\Product;
use App\Models\Review;
use App\Models\Seller;
use App\Models\Student;
use App\Models\Teacher;
use App\Models\User;
use App\Models\Verification;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    // public function run(): void
    // {
    //     // User::factory(10)->create();

    //     // User::firstOrCreate(
    //     //     ['email' => 'test@example.com'],
    //     //     [
    //     //         'name' => 'Test User',
    //     //         'password' => Hash::make('password'),
    //     //         'email_verified_at' => now(),
    //     //     ]
    //     // );

    //     $this->call([
    //         UserSeeder::class
    //     ]);

    // }

    // database/seeders/DatabaseSeeder.php
public function run(): void
{
    // 1. entity dasar dulu
    Category::factory(3)->create();
    Account::factory(10)->create();
    Verification::factory(10)->create();

    // 2. produk
    $products = Product::factory(20)->create();

    // 3. seller
    $sellers = Seller::factory(10)->create();

    // 4. attach product ke seller lewat pivot
    $sellers->each(function ($seller) use ($products) {
        $seller->products()->attach(
            $products->random(rand(1, 5))->pluck('id')->toArray()
        );
    });

    // 5. user roles
    Buyer::factory(10)->create();

    // 6. transaksi
    Order::factory(10)->create();
    OrderDetail::factory(20)->create();
    Review::factory(15)->create();

    // 7. admin
    Admin::factory(3)->create();

    // 8. optional user seeder
    $this->call([
        UserSeeder::class
    ]);
}

}
