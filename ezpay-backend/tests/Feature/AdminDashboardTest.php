<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AdminDashboardTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        // Seed default settings/data
        $this->seed();

        // Update password for existing admin seeded by DatabaseSeeder
        DB::table('admin_users')->where('email', 'admin@ezpay.id')->update([
            'password' => Hash::make('admin123'),
            'is_active' => true,
        ]);
    }

    /**
     * Test login view.
     */
    public function test_admin_login_page_loads()
    {
        $response = $this->get('/admin/login');
        $response->assertStatus(200);
    }

    /**
     * Test authentication success.
     */
    public function test_admin_login_success()
    {
        $response = $this->post('/admin/login', [
            'email' => 'admin@ezpay.id',
            'password' => 'admin123',
        ]);

        $response->assertRedirect('/admin');
        $this->assertEquals(session('admin_name'), 'Super Admin');
    }

    /**
     * Test authentication fails.
     */
    public function test_admin_login_wrong_credentials()
    {
        $response = $this->post('/admin/login', [
            'email' => 'admin@ezpay.id',
            'password' => 'wrongpassword',
        ]);

        $response->assertSessionHasErrors('login');
    }

    /**
     * Test protected routes redirect unauthenticated users.
     */
    public function test_unauthenticated_user_cannot_access_dashboard()
    {
        $response = $this->get('/admin');
        $response->assertRedirect('/admin/login');
    }

    /**
     * Test accessing dashboard after auth.
     */
    public function test_authenticated_admin_can_access_dashboard()
    {
        $response = $this->withSession([
            'admin_id' => 1,
            'admin_name' => 'Super Admin',
        ])->get('/admin');

        $response->assertStatus(200);
    }

    /**
     * Test manual balance addition from dashboard.
     */
    public function test_admin_can_add_balance_to_user()
    {
        $user = User::factory()->create([
            'balance' => 10000.00,
        ]);

        $response = $this->withSession([
            'admin_id' => 1,
            'admin_name' => 'Super Admin',
        ])->post("/admin/users/{$user->id}/add-balance", [
            'amount' => 25000,
        ]);

        $response->assertStatus(302); // Redirect back

        // Assert user's balance increased
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 35000.00, // 10000 + 25000
        ]);

        // Assert transaction log created
        $this->assertDatabaseHas('transactions', [
            'sender_id' => $user->id,
            'type' => 'top_up_saldo',
            'amount' => 25000.00,
            'status' => 'success',
            'payment_method' => 'admin_manual',
        ]);
    }
}
