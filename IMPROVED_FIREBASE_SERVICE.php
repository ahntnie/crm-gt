<?php

class FirebaseService {
    private $projectId = 'crm-gt-39eb3'; // Có thể config từ ngoài
    
    // Hàm mã hóa base64 an toàn cho JWT
    public function base64UrlEncode($data) {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    // Hàm lấy token truy cập OAuth 2.0
    public function getOAuthToken($serviceAccountFile) {
        if (!file_exists($serviceAccountFile)) {
            $error = "Error: Service account file not found at $serviceAccountFile";
            error_log($error);
            return ['error' => $error];
        }

        $json = json_decode(file_get_contents($serviceAccountFile), true);
        if (!$json) {
            $error = "Error: Invalid service account JSON";
            error_log($error);
            return ['error' => $error];
        }

        $clientEmail = $json['client_email'] ?? null;
        $privateKey = $json['private_key'] ?? null;
        $tokenUri = $json['token_uri'] ?? null;

        if (!$clientEmail || !$privateKey || !$tokenUri) {
            $error = "Error: Missing required fields in service account JSON";
            error_log($error);
            return ['error' => $error];
        }

        $header = ['alg' => 'RS256', 'typ' => 'JWT'];
        $payload = [
            'iss' => $clientEmail,
            'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
            'aud' => $tokenUri,
            'exp' => time() + 3600,
            'iat' => time()
        ];

        $base64Header = $this->base64UrlEncode(json_encode($header));
        $base64Payload = $this->base64UrlEncode(json_encode($payload));
        $data = "$base64Header.$base64Payload";
        
        if (!openssl_sign($data, $signature, $privateKey, 'SHA256')) {
            $error = "Error: Failed to sign JWT";
            error_log($error);
            return ['error' => $error];
        }
        
        $base64Signature = $this->base64UrlEncode($signature);
        $jwt = "$base64Header.$base64Payload.$base64Signature";

        $ch = curl_init($tokenUri);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion' => $jwt
        ]));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

        if (curl_errno($ch)) {
            $error = "CURL error: " . curl_error($ch);
            error_log($error);
            curl_close($ch);
            return ['error' => $error];
        }

        curl_close($ch);
        
        if ($httpCode !== 200) {
            $error = "HTTP error $httpCode: $response";
            error_log($error);
            return ['error' => $error];
        }
        
        $responseData = json_decode($response, true);
        if (isset($responseData['error'])) {
            $error = "OAuth error: " . ($responseData['error_description'] ?? $responseData['error']);
            error_log($error);
            return ['error' => $error];
        }

        $accessToken = $responseData['access_token'] ?? null;
        if (!$accessToken) {
            $error = "Error: Failed to get access token";
            error_log($error);
            return ['error' => $error];
        }

        return $accessToken;
    }

    // Hàm gửi thông báo FCM tới nhiều device tokens (DATA-ONLY MESSAGES)
    public function sendFcmNotification($accessToken, $deviceTokens, $title, $body, $idNoti, $idThread) {
        // Validation
        if (empty($accessToken)) {
            return ['error' => 'Access token is required'];
        }
        if (empty($deviceTokens) || !is_array($deviceTokens)) {
            return ['error' => 'Device tokens array is required'];
        }
        if (empty($title) || empty($body)) {
            return ['error' => 'Title and body are required'];
        }

        $url = "https://fcm.googleapis.com/v1/projects/{$this->projectId}/messages:send";
        $headers = [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json'
        ];

        error_log("🚀 Sending FCM notifications to " . count($deviceTokens) . " devices");
        error_log("📝 Message: $title - $body");
        error_log("🔗 idNoti: $idNoti, idThread: $idThread");

        $results = [];
        $successCount = 0;
        $failureCount = 0;

        foreach ($deviceTokens as $deviceToken) {
            if (empty(trim($deviceToken))) {
                $results[$deviceToken] = ['error' => 'Empty device token'];
                $failureCount++;
                continue;
            }

            // ✅ DATA-ONLY MESSAGE - Đảm bảo âm thanh tùy chỉnh hoạt động khi app terminated
            $notification = [
                'message' => [
                    'token' => trim($deviceToken),
                    // ❌ KHÔNG dùng notification payload - sẽ không có âm thanh tùy chỉnh khi app terminated
                    // 'notification' => [
                    //     'title' => $title,
                    //     'body' => $body
                    // ],
                    
                    // ✅ CHỈ dùng data payload - đảm bảo âm thanh tùy chỉnh hoạt động
                    'data' => [
                        'title' => (string)$title,
                        'body' => (string)$body,
                        'idNoTi' => (string)$idNoti,
                        'idThread' => (string)$idThread,
                        'timestamp' => (string)time(),
                        'notification_type' => 'message'
                    ]
                ]
            ];

            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($notification));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

            if (curl_errno($ch)) {
                $error = "CURL error for token " . substr($deviceToken, 0, 20) . "...: " . curl_error($ch);
                error_log($error);
                $results[$deviceToken] = ['error' => $error];
                $failureCount++;
            } else if ($httpCode !== 200) {
                $error = "HTTP error $httpCode for token " . substr($deviceToken, 0, 20) . "...: $response";
                error_log($error);
                $results[$deviceToken] = ['error' => $error, 'http_code' => $httpCode];
                $failureCount++;
            } else {
                $responseData = json_decode($response, true);
                if (isset($responseData['error'])) {
                    $error = "FCM error for token " . substr($deviceToken, 0, 20) . "...: " . json_encode($responseData['error']);
                    error_log($error);
                    $results[$deviceToken] = ['error' => $error, 'fcm_error' => $responseData['error']];
                    $failureCount++;
                } else {
                    error_log("✅ FCM success for token " . substr($deviceToken, 0, 20) . "...");
                    $results[$deviceToken] = $responseData;
                    $successCount++;
                }
            }
            curl_close($ch);
        }

        error_log("📊 FCM Results: $successCount success, $failureCount failed");
        return $results;
    }

    // Hàm gửi với retry mechanism
    public function sendWithRetry($accessToken, $deviceTokens, $title, $body, $idNoti, $idThread, $maxRetries = 2) {
        $results = [];
        $retryTokens = $deviceTokens;
        
        for ($attempt = 1; $attempt <= $maxRetries; $attempt++) {
            error_log("🔄 FCM Attempt $attempt/$maxRetries for " . count($retryTokens) . " tokens");
            
            $batchResults = $this->sendFcmNotification($accessToken, $retryTokens, $title, $body, $idNoti, $idThread);
            
            $newRetryTokens = [];
            foreach ($batchResults as $token => $result) {
                if (isset($result['error']) && $attempt < $maxRetries) {
                    // Retry on specific errors
                    if (isset($result['http_code']) && in_array($result['http_code'], [500, 502, 503, 504])) {
                        $newRetryTokens[] = $token;
                        error_log("🔄 Will retry token " . substr($token, 0, 20) . "... due to HTTP " . $result['http_code']);
                    } else {
                        $results[$token] = $result; // Don't retry client errors
                    }
                } else {
                    $results[$token] = $result; // Final result
                }
            }
            
            $retryTokens = $newRetryTokens;
            if (empty($retryTokens)) {
                break; // All done
            }
            
            if ($attempt < $maxRetries) {
                sleep(1); // Wait before retry
            }
        }
        
        return $results;
    }

    // Utility function để test với 1 token
    public function sendTestNotification($accessToken, $deviceToken, $title = "Test Notification", $body = "Testing custom sound") {
        return $this->sendFcmNotification(
            $accessToken, 
            [$deviceToken], 
            $title, 
            $body, 
            'test_' . time(), 
            'test_thread_' . time()
        );
    }
}

// Example usage:
/*
$firebase = new FirebaseService();
$accessToken = $firebase->getOAuthToken('path/to/service-account.json');

if (is_array($accessToken) && isset($accessToken['error'])) {
    echo "❌ Error getting token: " . $accessToken['error'] . "\n";
} else {
    echo "✅ Got access token\n";
    
    $deviceTokens = ['YOUR_FCM_TOKEN_HERE'];
    $results = $firebase->sendWithRetry(
        $accessToken,
        $deviceTokens,
        'Tin nhắn mới',
        'Bạn có tin nhắn từ John Doe',
        '123',
        '456'
    );
    
    foreach ($results as $token => $result) {
        $shortToken = substr($token, 0, 20) . '...';
        if (isset($result['error'])) {
            echo "❌ Failed for $shortToken: " . $result['error'] . "\n";
        } else {
            echo "✅ Success for $shortToken\n";
        }
    }
}
*/
?>
