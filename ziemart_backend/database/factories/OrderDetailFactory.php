<?php

namespace Database\Factories;

use App\Models\OrderDetail;
use App\Models\Product;
use App\Models\Order;
use Illuminate\Database\Eloquent\Factories\Factory;

class OrderDetailFactory extends Factory
{
    protected $model = OrderDetail::class;

    public function definition(): array
    {
        $quantity = $this->faker->numberBetween(1, 5);
        $price = $this->faker->numberBetween(10000, 200000);

        return [
            'product_id' => Product::inRandomOrder()->first()->id,
            'order_id' => Order::inRandomOrder()->first()->id,
            'quantity' => $quantity,
            'total_price' => $quantity * $price,
        ];
    }
}
