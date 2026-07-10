<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AdminAuthController extends Controller
{
    public function showLogin()
    {
        if (session()->has('admin_id')) {
            return redirect()->route('admin.dashboard');
        }
        return view('admin.login');
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $admin = DB::table('admin_users')
            ->where('email', $request->email)
            ->where('is_active', true)
            ->first();

        if ($admin && Hash::check($request->password, $admin->password)) {
            session([
                'admin_id' => $admin->id,
                'admin_name' => $admin->name,
                'admin_role' => $admin->role,
            ]);

            // Update last login
            DB::table('admin_users')->where('id', $admin->id)->update([
                'last_login_at' => now(),
            ]);

            return redirect()->route('admin.dashboard')->with('success', 'Selamat datang kembali, ' . $admin->name);
        }

        return back()->withErrors(['login' => 'Email atau Password salah, atau akun Anda dinonaktifkan.']);
    }

    public function logout()
    {
        session()->forget(['admin_id', 'admin_name', 'admin_role']);
        return redirect()->route('admin.login')->with('success', 'Berhasil logout');
    }
}
