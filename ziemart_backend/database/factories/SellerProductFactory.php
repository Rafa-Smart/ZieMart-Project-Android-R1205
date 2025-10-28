<?php

namespace Database\Factories;

use App\Models\Seller;
use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

class SellerProductFactory extends Factory
{
    public function definition(): array
    {
        return [
            'seller_id' => Seller::inRandomOrder()->first()?->id,
            'product_id' => Product::inRandomOrder()->first()?->id,
        ];
    }
}
