<?php

namespace App\Services;

use App\Models\UserFcmToken;
use Illuminate\Support\Facades\Log;
use Kreait\Laravel\Firebase\Facades\Firebase;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class NotificationService
{
    /**
     * Send push notification to specific user(s)
     *
     * @param int|array $userIds
     * @param string $title
     * @param string $body
     * @param array $data
     * @return array Status of sent notifications
     */
    public function sendNotification($userIds, string $title, string $body, array $data = []): array
    {
        $userIds = is_array($userIds) ? $userIds : [$userIds];

        // Retrieve active FCM tokens
        $tokens = UserFcmToken::whereIn('user_id', $userIds)
            ->where('is_active', true)
            ->pluck('fcm_token')
            ->toArray();

        if (empty($tokens)) {
            Log::info("No active FCM tokens found for users: " . implode(',', $userIds));
            return ['success' => 0, 'failed' => 0, 'tokens_sent' => 0];
        }

        // Check if FCM is enabled in env/config (default false in testing/local)
        $fcmEnabled = env('FIREBASE_FCM_ENABLED', false);

        if (!$fcmEnabled || app()->environment('testing')) {
            Log::info("FCM Notification (MOCKED): Title: {$title} | Body: {$body} | Target Users: " . implode(',', $userIds) . " | Data: " . json_encode($data));
            return ['success' => count($tokens), 'failed' => 0, 'tokens_sent' => count($tokens)];
        }

        try {
            $messaging = Firebase::messaging();
            $notification = Notification::create($title, $body);
            
            // Build message with data
            $message = CloudMessage::new()
                ->withNotification($notification)
                ->withData($data);

            $report = $messaging->sendMulticast($message, $tokens);
            
            $successCount = $report->successes()->count();
            $failedCount = $report->failures()->count();

            // Handle failed tokens (e.g., expired or unregistered)
            if ($report->hasFailures()) {
                foreach ($report->failures()->getItems() as $failure) {
                    $token = $failure->target()->value();
                    $error = $failure->error()->getMessage();
                    
                    Log::warning("FCM delivery failed for token {$token}: {$error}");

                    // Mark token as inactive if it's unregistered/invalid
                    UserFcmToken::where('fcm_token', $token)->update(['is_active' => false]);
                }
            }

            Log::info("FCM Notification Sent: {$successCount} succeeded, {$failedCount} failed.");

            return [
                'success' => $successCount,
                'failed' => $failedCount,
                'tokens_sent' => count($tokens)
            ];

        } catch (\Exception $e) {
            Log::error("FCM Send Exception: " . $e->getMessage());
            return ['success' => 0, 'failed' => count($tokens), 'error' => $e->getMessage()];
        }
    }
}
