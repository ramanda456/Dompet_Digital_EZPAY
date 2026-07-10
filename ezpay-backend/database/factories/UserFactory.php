<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * @extends Factory<User>
 */
class UserFactory extends Factory
{
    /**
     * The current password being used by the factory.
     */
    protected static ?string $password;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'firebase_uid' => 'fake_uid_' . Str::random(20),
            'name' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'phone' => '08' . fake()->unique()->numerify('##########'),
            'nik' => fake()->unique()->numerify('3171##############'),
            'gender' => fake()->randomElement(['Laki-laki', 'Perempuan']),
            'profile_picture' => null,
            'pin' => Hash::make('123456'), // Default PIN 123456
            'balance' => 0.00,
            'status' => 'active',
            'email_verified_at' => now(),
            'password' => static::$password ??= Hash::make('password'),
            'remember_token' => Str::random(10),
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     */
    public function unverified(): static
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}
