<?php

namespace Database\Factories;

use App\Models\Verification;
use App\Models\Account;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class VerificationFactory extends Factory
{
    protected $model = Verification::class;

    public function definition(): array
    {
        return [
            'verification_code' => $this->faker->uuid(),
            'reason' => $this->faker->sentence(),
            'status' => $this->faker->randomElement(['pending', 'approved', 'rejected']),
            'account_id' => Account::inRandomOrder()->first()->id,
        ];
    }
}
