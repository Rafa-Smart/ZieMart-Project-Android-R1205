<?php

namespace Database\Factories;

use App\Models\Order;
use App\Models\Product;
use App\Models\Buyer;
use Illuminate\Database\Eloquent\Factories\Factory;

class OrderFactory extends Factory
{
    protected $model = Order::class;

    public function definition(): array
    {
        return [
            'product_id' => Product::inRandomOrder()->first()->id,
            'buyer_id' => Buyer::inRandomOrder()->first()->id,
        ];
    }
}
