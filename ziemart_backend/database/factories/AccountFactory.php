<?php

namespace Database\Factories;

use App\Models\Account;
use App\Models\Student;
use App\Models\Teacher;
use Illuminate\Database\Eloquent\Factories\Factory;

class AccountFactory extends Factory
{
    protected $model = Account::class;

    public function definition(): array
    {
        return [
            'username' => $this->faker->unique()->userName(),
            'email' => $this->faker->unique()->safeEmail(),
            'role' => $this->faker->randomElement(['seller', 'buyer']),
            'password' => bcrypt('password'),
        ];
    }
}
// test