<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class AuthController extends Controller
{
    /**
     * Register a new user in MySQL database.
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'firebase_uid' => 'required|string|unique:users,firebase_uid',
            'name' => 'required|string|max:100',
            'email' => 'required|email|max:100|unique:users,email',
            'phone' => 'required|string|max:20|unique:users,phone',
            'nik' => 'required|string|size:16|unique:users,nik',
            'gender' => ['required', Rule::in(['Laki-laki', 'Perempuan'])],
            'pin' => 'required|string|size:6', // 6-digit PIN
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $user = User::create([
                'firebase_uid' => $request->firebase_uid,
                'name' => $request->name,
                'email' => $request->email,
                'phone' => $request->phone,
                'nik' => $request->nik,
                'gender' => $request->gender,
                'pin' => Hash::make($request->pin),
                'balance' => 0.00,
                'status' => 'active',
            ]);

            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Registrasi berhasil',
                'data' => [
                    'user' => $user,
                    'token' => $token,
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Login user based on Firebase UID.
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'firebase_uid' => 'required|string',
            'fcm_token' => 'nullable|string',
            'device_info' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $user = User::where('firebase_uid', $request->firebase_uid)->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User belum terdaftar di database MySQL',
                    'code' => 'USER_NOT_FOUND'
                ], 404);
            }

            if ($user->status === 'suspended') {
                return response()->json([
                    'success' => false,
                    'message' => 'Akun Anda ditangguhkan. Silakan hubungi admin.',
                    'code' => 'USER_SUSPENDED'
                ], 403);
            }

            // Save/Update FCM Token if provided
            if ($request->filled('fcm_token')) {
                \Illuminate\Support\Facades\DB::table('user_fcm_tokens')->updateOrInsert(
                    [
                        'user_id' => $user->id,
                        'fcm_token' => $request->fcm_token
                    ],
                    [
                        'device_info' => $request->device_info,
                        'is_active' => true,
                        'updated_at' => now(),
                        'created_at' => now(),
                    ]
                );
            }

            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login berhasil',
                'data' => [
                    'user' => $user,
                    'token' => $token,
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get authenticated user profile.
     */
    public function profile(Request $request)
    {
        return response()->json([
            'success' => true,
            'message' => 'Data profil berhasil diambil',
            'data' => $request->user()
        ]);
    }

    /**
     * Update user profile.
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|max:100',
            'phone' => ['nullable', 'string', 'max:20', Rule::unique('users', 'phone')->ignore($user->id)],
            'profile_picture' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $user->update($request->only(['name', 'phone', 'profile_picture']));

            return response()->json([
                'success' => true,
                'message' => 'Profil berhasil diperbarui',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Logout / Revoke token.
     */
    public function logout(Request $request)
    {
        try {
            $request->user()->currentAccessToken()->delete();

            return response()->json([
                'success' => true,
                'message' => 'Logout berhasil'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
