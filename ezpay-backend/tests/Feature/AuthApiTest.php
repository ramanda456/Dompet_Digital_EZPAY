<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test user registration via API.
     */
    public function test_user_can_register_via_api(): void
    {
        $response = $this->postJson('/api/register', [
            'firebase_uid' => 'test_firebase_uid_123',
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'phone' => '081234567890',
            'nik' => '3171012345678901',
            'gender' => 'Laki-laki',
            'pin' => '123456',
        ]);

        $response->assertStatus(201)
                 ->assertJsonStructure([
                     'success',
                     'message',
                     'data' => [
                         'user' => [
                             'id',
                             'firebase_uid',
                             'name',
                             'email',
                             'phone',
                             'nik',
                             'gender',
                             'balance',
                             'status',
                             'created_at',
                             'updated_at',
                         ],
                         'token',
                     ],
                 ]);

        $this->assertDatabaseHas('users', [
            'email' => 'john@example.com',
            'firebase_uid' => 'test_firebase_uid_123',
        ]);
    }

    /**
     * Test user login via API.
     */
    public function test_user_can_login_via_api(): void
    {
        // Create user first
        $user = User::factory()->create([
            'firebase_uid' => 'existing_uid_123',
            'email' => 'existing@example.com',
        ]);

        $response = $this->postJson('/api/login', [
            'firebase_uid' => 'existing_uid_123',
            'fcm_token' => 'fcm_token_test_abc',
            'device_info' => 'iPhone 15 Pro',
        ]);

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'success',
                     'message',
                     'data' => [
                         'user',
                         'token',
                     ],
                 ]);

        $this->assertDatabaseHas('user_fcm_tokens', [
            'user_id' => $user->id,
            'fcm_token' => 'fcm_token_test_abc',
        ]);
    }

    /**
     * Test access to profile.
     */
    public function test_user_can_access_profile_with_token(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test_token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/profile');

        $response->assertStatus(200)
                 ->assertJsonPath('data.email', $user->email);
    }
}
