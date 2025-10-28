<?php

namespace Database\Factories;

use App\Models\Seller;
use App\Models\Verification;
use App\Models\Product;
use App\Models\Student;
use App\Models\Teacher;
use App\Models\Account;
use Illuminate\Database\Eloquent\Factories\Factory;

class SellerFactory extends Factory
{
    protected $model = Seller::class;

    public function definition(): array
    {
        return [
            'store_name' => $this->faker->unique()->company(),
            'phone_number' => $this->faker->unique()->phoneNumber(),
            'verification_id' => Verification::inRandomOrder()->first()->id,
            'account_id' => Account::inRandomOrder()->first()->id,
        ];
    }
}
