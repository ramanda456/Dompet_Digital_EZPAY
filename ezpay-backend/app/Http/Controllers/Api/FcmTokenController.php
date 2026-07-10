<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserFcmToken;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class FcmTokenController extends Controller
{
    /**
     * Store or update FCM token for the authenticated user.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'fcm_token' => 'required|string|max:512',
            'device_info' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();

        // Update or create token record
        $token = UserFcmToken::updateOrCreate(
            [
                'user_id' => $user->id,
                'fcm_token' => $request->fcm_token,
            ],
            [
                'device_info' => $request->device_info,
                'is_active' => true,
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'FCM Token berhasil disimpan',
            'data' => $token,
        ]);
    }

    /**
     * Deactivate FCM token (e.g. on logout)
     */
    public function destroy(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'fcm_token' => 'required|string|max:512',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();

        UserFcmToken::where('user_id', $user->id)
            ->where('fcm_token', $request->fcm_token)
            ->update(['is_active' => false]);

        return response()->json([
            'success' => true,
            'message' => 'FCM Token berhasil dinonaktifkan',
        ]);
    }
}
