<?php

namespace Database\Factories;

use App\Models\Buyer;
use App\Models\Student;
use App\Models\Teacher;
use App\Models\Account;
use Illuminate\Database\Eloquent\Factories\Factory;

class BuyerFactory extends Factory
{
    protected $model = Buyer::class;

    public function definition(): array
    {
        return [
            'fullname' => $this->faker->name(),
            'phone_number' => $this->faker->unique()->phoneNumber(),
            'account_id' => Account::factory(),
        ];
    }
}
