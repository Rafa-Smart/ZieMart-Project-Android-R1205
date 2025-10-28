<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Seller;
use App\Models\Product;

class SellerProductSeeder extends Seeder
{
    public function run(): void
    {
        $sellers = Seller::all();
        $products = Product::all();

        $sellers->each(function ($seller) use ($products) {
            $seller->products()->attach(
                $products->random(rand(1, 5))->pluck('id')->toArray()
            );
        });
    }
}
