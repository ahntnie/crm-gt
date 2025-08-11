# Đánh giá code PHP FCM Service

## ✅ **Những điều làm ĐÚNG:**

### 1. **Data-Only Messages** (Quan trọng nhất!)
```php
// ✅ ĐÚNG - Đã comment notification payload
// 'notification' => [
//     'title' => $title,
//     'body' => $body
// ],

// ✅ ĐÚNG - Chỉ gửi data payload
'data' => [
    'title' => $title,
    'body' => $body,
    'promo_type' => 'default_promo',
    'idNoTi' => $idNoti,
    'idThread' => $idThread,
    'key2' => 'value2'
]
```
**→ Điều này đảm bảo âm thanh tùy chỉnh hoạt động khi app terminated!**

### 2. **OAuth 2.0 Implementation**
- JWT signing với RS256 ✅
- Proper error handling ✅
- Service account authentication ✅

### 3. **Batch Processing**
- Gửi tới nhiều device tokens ✅
- Error handling cho từng token ✅

## 🔧 **Cải thiện đề xuất:**

### 1. **Thêm validation cho required fields:**
```php
public function sendFcmNotification($accessToken, $deviceTokens, $title, $body, $idNoti, $idThread) {
    // Validate input
    if (empty($accessToken)) {
        return ['error' => 'Access token is required'];
    }
    if (empty($deviceTokens) || !is_array($deviceTokens)) {
        return ['error' => 'Device tokens array is required'];
    }
    if (empty($title) || empty($body)) {
        return ['error' => 'Title and body are required'];
    }
    
    // Rest of your code...
}
```

### 2. **Cải thiện error handling:**
```php
// Thêm HTTP status code check
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
if ($httpCode !== 200) {
    $error = "HTTP error $httpCode for token $deviceToken: $response";
    error_log($error);
    $results[$deviceToken] = ['error' => $error, 'http_code' => $httpCode];
    curl_close($ch);
    continue;
}
```

### 3. **Thêm retry mechanism cho failed tokens:**
```php
public function sendWithRetry($accessToken, $deviceTokens, $title, $body, $idNoti, $idThread, $maxRetries = 3) {
    $results = [];
    $retryTokens = $deviceTokens;
    
    for ($attempt = 1; $attempt <= $maxRetries; $attempt++) {
        $batchResults = $this->sendFcmNotification($accessToken, $retryTokens, $title, $body, $idNoti, $idThread);
        
        $retryTokens = [];
        foreach ($batchResults as $token => $result) {
            if (isset($result['error']) && $attempt < $maxRetries) {
                $retryTokens[] = $token; // Retry failed tokens
            } else {
                $results[$token] = $result; // Final result
            }
        }
        
        if (empty($retryTokens)) {
            break; // All successful
        }
        
        sleep(1); // Wait before retry
    }
    
    return $results;
}
```

### 4. **Thêm logging chi tiết hơn:**
```php
// Trong sendFcmNotification
error_log("Sending FCM to " . count($deviceTokens) . " devices");
error_log("Message data: " . json_encode(['title' => $title, 'body' => $body, 'idNoti' => $idNoti, 'idThread' => $idThread]));

// Log success/failure summary
$successCount = 0;
$failureCount = 0;
foreach ($results as $result) {
    if (isset($result['error'])) {
        $failureCount++;
    } else {
        $successCount++;
    }
}
error_log("FCM Results: $successCount success, $failureCount failed");
```

### 5. **Cải thiện data structure:**
```php
'data' => [
    'title' => $title,
    'body' => $body,
    'idNoTi' => (string)$idNoti,        // Ensure string
    'idThread' => (string)$idThread,    // Ensure string
    'timestamp' => (string)time(),      // Add timestamp
    'notification_type' => 'message',   // Add type
    // Remove unnecessary fields
    // 'promo_type' => 'default_promo',
    // 'key2' => 'value2'
]
```

## 📱 **Test với code hiện tại:**

Code của bạn sẽ hoạt động tốt! Để test:

1. **Gọi hàm:**
```php
$firebase = new FirebaseService();
$accessToken = $firebase->getOAuthToken('path/to/service-account.json');

if (is_array($accessToken) && isset($accessToken['error'])) {
    echo "Error getting token: " . $accessToken['error'];
} else {
    $deviceTokens = ['FCM_TOKEN_1', 'FCM_TOKEN_2'];
    $results = $firebase->sendFcmNotification(
        $accessToken,
        $deviceTokens,
        'Test Title',
        'Test Body',
        '123',
        '456'
    );
    
    foreach ($results as $token => $result) {
        if (isset($result['error'])) {
            echo "Failed for $token: " . $result['error'] . "\n";
        } else {
            echo "Success for $token\n";
        }
    }
}
```

## ✅ **Kết luận:**

Code của bạn **ĐÃ ĐÚNG** và sẽ gửi data-only messages, đảm bảo âm thanh tùy chỉnh hoạt động khi app terminated. Chỉ cần thêm một số cải thiện nhỏ về error handling và validation.
