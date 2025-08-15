<?php

header("Access-Control-Allow-Origin: *");
require_once __DIR__ . "/../core/FirebaseService.php";
require dirname(__DIR__) . "/vendor/autoload.php";
require_once dirname(__DIR__) . "/vendor/firebase/php-jwt/src/JWT.php";
require_once dirname(__DIR__) . "/vendor/firebase/php-jwt/src/Key.php";
require_once __DIR__ . "/../core/jwt.php";

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Firebase\JWT\ExpiredException;
use Firebase\JWT\SignatureInvalidException;
use Firebase\JWT\BeforeValidException;

class productModel extends DB
{
    function CreateDir(
        $name_dir,
        $created_by,
        $created_date,
        &$dir_id,
        &$errortext,
        $type = "root",
        $level = 0,
        $parent_id = null
    ) {
        if (
            empty($name_dir) ||
            empty($created_by) ||
            empty($created_date) ||
            empty($type)
        ) {
            $errortext = "Missing parameters";
            return -1;
        }

        $sql1 = "SELECT f_create_id() as newid";
        $result1 = $this->executeResult($sql1, true);
        if (empty($result1["newid"])) {
            $errortext = "Failed to generate new ID";
            return -1;
        }
        $dir_id = $result1["newid"];

        $columns = ["id", "name", "created_by", "created_at", "type", "level"];
        $values = [
            "'$dir_id'",
            "'$name_dir'",
            "'$created_by'",
            "'$created_date'",
            "'$type'",
            "'$level'",
        ];
        if ($parent_id !== null) {
            $columns[] = "parent_id";
            $values[] = "'$parent_id'";
        }

        $sql =
            "INSERT INTO dir (" .
            implode(", ", $columns) .
            ") VALUES (" .
            implode(", ", $values) .
            ")";
        $rtn = $this->execute($sql, $errortext);
        if ($rtn != 1) {
            return -1;
        }

        // Nếu là dir có loại cần chat, tạo chat_thread và tự thêm creator vào chat_participant
        if ($type === "investor" || $type === "supplier") {
            // Gán id của chat_thread bằng dir_id
            $sqlChat = "INSERT INTO chat_thread (id, dir_id, created_by) VALUES ('$dir_id', '$dir_id', '$created_by') 
                        ON DUPLICATE KEY UPDATE dir_id = VALUES(dir_id), created_by = VALUES(created_by)";
            $this->execute($sqlChat, $errortext);

            $thread_id = $dir_id; // Sử dụng dir_id làm thread_id
            $this->AddParticipantToThread($thread_id, $created_by); // auto add creator to chat
        }

        return 1;
    }

    function CreateFullDirStructure($name_root, $user_id, &$errortext)
    {
        date_default_timezone_set("Asia/Ho_Chi_Minh");
        $created_date = date("Y-m-d H:i:s");

        if (
            $this->CreateDir(
                $name_root,
                $user_id,
                $created_date,
                $root_id,
                $errortext,
                "root",
                0,
                null,
            ) != 1
        ) {
            return -1;
        }

        $subDirs = [
            ["name" => "Chủ đầu tư", "type" => "investor"],
            ["name" => "Nhà cung cấp", "type" => "supplier"],
        ];
        $childDirs = [
            "contract" => "Hợp đồng",
            "acceptance" => "Nghiệm thu",
            "settlement" => "Quyết toán",
            "progress" => "Tiến độ",
        ];

        foreach ($subDirs as $sub) {
            if (
                $this->CreateDir(
                    $sub["name"],
                    $user_id,
                    $created_date,
                    $sub_id,
                    $errortext,
                    $sub["type"],
                    1,
                    $root_id,
                ) != 1
            ) {
                return -1;
            }
            foreach ($childDirs as $type => $name) {
                if (
                    $this->CreateDir(
                        $name,
                        $user_id,
                        $created_date,
                        $child_id,
                        $errortext,
                        $type,
                        2,
                        $sub_id,
                    ) != 1
                ) {
                    return -1;
                }
            }
        }

        return 1;
    }

    function AddParticipantToThread($thread_id, $user_id)
    {
        $check = "SELECT id FROM chat_participant WHERE thread_id = '$thread_id' AND user_id = '$user_id'";
        $exist = $this->executeResult($check, true);
        if ($exist) {
            return ["status" => 0, "msg" => "User already in thread"];
        }

        $sql = "INSERT INTO chat_participant (thread_id, user_id) VALUES ('$thread_id', '$user_id')";
        $errortext = "";
        $rtn = $this->execute($sql, $errortext);

        if ($rtn != 1) {
            return [
                "status" => -1,
                "msg" => "Insert error",
                "debug" => ["sql" => $sql, "err" => $errortext, "rtn" => $rtn],
            ];
        }

        return ["status" => 1, "msg" => "Success"];
    }
    function InvantedToThread($thread_id, $phone)
    {
        // Tìm user_id từ số điện thoại
        $sqlFind = "SELECT id FROM user WHERE phone = '$phone'";
        $user = $this->executeResult($sqlFind, true);

        if (!$user) {
            return [
                "status" => -1,
                "msg" => "Không tìm thấy người dùng với số điện thoại này",
            ];
        }

        $user_id = $user["id"];

        // Kiểm tra đã tham gia chưa
        $check = "SELECT id FROM chat_participant WHERE thread_id = '$thread_id' AND user_id = '$user_id'";
        $exist = $this->executeResult($check, true);
        if ($exist) {
            return [
                "status" => 1,
                "msg" => "Người dùng đã có trong đoạn hội thoại!",
            ];
        }

        // Thêm vào thread
        $sql = "INSERT INTO chat_participant (thread_id, user_id) VALUES ('$thread_id', '$user_id')";
        $errortext = "";
        $rtn = $this->execute($sql, $errortext);

        if ($rtn != 1) {
            return [
                "status" => -1,
                "msg" => "Insert error",
                "debug" => ["sql" => $sql, "err" => $errortext, "rtn" => $rtn],
            ];
        }

        return ["status" => 1, "msg" => "Mời người dùng thành công!"];
    }

    function GetUnreadNotification($dir_id)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return [
                "status" => -1,
                "msg" => "Missing token",
            ];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;

            if (!$user_id) {
                throw new Exception("Missing user ID in token");
            }

            // Kiểm tra dir có tồn tại không
            $stmt = $this->conn->prepare(
                "SELECT id, parent_id FROM dir WHERE id = ?",
            );
            $stmt->bind_param("i", $dir_id);
            $stmt->execute();
            $dirData = $stmt->get_result()->fetch_assoc();

            if (!$dirData) {
                return [
                    "status" => -1,
                    "msg" => "Thư mục không tồn tại hoặc đã bị xoá",
                    "data" => null,
                ];
            }

            $isParent = is_null($dirData["parent_id"]);

            if ($isParent) {
                // dir là cha → lấy tất cả unread từ các dir con (cấp 1 và 2)
                $sql = "
                      WITH RECURSIVE dir_tree AS (
                          SELECT id FROM dir WHERE parent_id = ?
                          UNION ALL
                          SELECT d.id
                          FROM dir d
                          INNER JOIN dir_tree dt ON d.parent_id = dt.id
                      )
                      SELECT SUM(cp.unread_count) AS unread_count
                      FROM chat_participant cp
                      JOIN chat_thread ct ON cp.thread_id = ct.id
                      WHERE cp.user_id = ? AND ct.dir_id IN (SELECT id FROM dir_tree)
                  ";
                $stmt = $this->conn->prepare($sql);
                $stmt->bind_param("ii", $dir_id, $user_id);
                $stmt->execute();
                $result = $stmt->get_result();
                $data = $result->fetch_assoc();
                $totalUnread =
                    $data && isset($data["unread_count"])
                        ? (int) $data["unread_count"]
                        : 0;

                return [
                    "status" => 1,
                    "msg" => "Success",
                    "data" => [
                        "dir_type" => "parent",
                        "thread_id" => $dir_id,
                        "unread_count" => $totalUnread,
                    ],
                ];
            } else {
                // dir là con → chỉ có 1 thread
                $stmt = $this->conn->prepare("
                      SELECT cp.thread_id, cp.unread_count
                      FROM chat_participant cp
                      JOIN chat_thread ct ON cp.thread_id = ct.id
                      WHERE cp.user_id = ? AND ct.dir_id = ?
                  ");
                $stmt->bind_param("ii", $user_id, $dir_id);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($row = $result->fetch_assoc()) {
                    return [
                        "status" => 1,
                        "msg" => "Success",
                        "data" => [
                            "dir_type" => "child",
                            "thread_id" => $dir_id,
                            "unread_count" => (int) $row["unread_count"],
                        ],
                    ];
                } else {
                    return [
                        "status" => -1,
                        "msg" => "Bạn không có quyền xem thread này",
                        "data" => [
                            "dir_type" => "child",
                            "unread_count" => 0,
                        ],
                    ];
                }
            }
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }
    function GetChatThreadByDir($dir_id)
    {
        // Lấy token và decode user_id
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Missing user ID in token");
            }

            // Lấy thread_id từ dir_id
            $dir_id = $this->conn->real_escape_string($dir_id);
            $sql = "SELECT id FROM chat_thread WHERE dir_id = '$dir_id' LIMIT 1";
            $thread = $this->executeResult($sql, true);
            if (!$thread) {
                return [
                    "status" => 0,
                    "msg" => "Thread not found for dir_id = $dir_id",
                ];
            }

            $thread_id = $thread["id"];

            // Kiểm tra user có trong thread không
            $check = "SELECT id FROM chat_participant WHERE thread_id = '$thread_id' AND user_id = '$user_id'";
            $exist = $this->executeResult($check, true);
            if (!$exist) {
                return [
                    "status" => 0,
                    "msg" =>
                        "Access denied. You are not a participant of this chat thread.",
                ];
            }

            // Lấy message kèm file đính kèm (nếu có)
            $sql_msg = "
          SELECT 
              cm.id AS chat_id,
              cm.thread_id,
              cm.user_id,
              u.name AS user_name,
              cm.message,
              cm.sent_at,
              a.file_name,
              CONCAT('https://crm.gtglobal.com.vn/mvc/', REPLACE(a.file_path, '\\\\', '/')) AS file_url,
              a.file_type
          FROM chat_message cm
          LEFT JOIN user u ON cm.user_id = u.id
          LEFT JOIN attachment a ON a.chat_id = cm.id
          WHERE cm.thread_id = '$thread_id'
          ORDER BY cm.sent_at ASC
      ";

            $messages = $this->executeResult($sql_msg);

            return [
                "status" => 1,
                "msg" => "Success",
                "id_thread" => $thread_id,
                "data" => $messages,
            ];
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }
    function GetDirCustomer_FromToken(&$result)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Missing user ID in token");
            }

            // Lấy tất cả các thư mục mà user được quyền xem:
            $sql = "
                -- 1. Thư mục do user tạo
                SELECT d.*, d2.name AS parent_name
                FROM dir d
                LEFT JOIN dir d2 ON d.parent_id = d2.id
                WHERE d.created_by = '$user_id'

                UNION

                -- 2. Dir con mà user được mời vào (chat_participant)
                SELECT DISTINCT d.*, d2.name AS parent_name
                FROM chat_participant cp
                JOIN chat_thread ct ON cp.thread_id = ct.id
                JOIN dir d ON ct.dir_id = d.id
                LEFT JOIN dir d2 ON d.parent_id = d2.id
                WHERE cp.user_id = '$user_id'

                UNION

                -- 3. Dir cha của các dir con mà user được mời
                SELECT DISTINCT d_parent.*, d_grand.name AS parent_name
                FROM chat_participant cp
                JOIN chat_thread ct ON cp.thread_id = ct.id
                JOIN dir d_child ON ct.dir_id = d_child.id
                JOIN dir d_parent ON d_child.parent_id = d_parent.id
                LEFT JOIN dir d_grand ON d_parent.parent_id = d_grand.id
                WHERE cp.user_id = '$user_id'

                UNION

                -- 4. Các dir nhỏ (hợp đồng, nghiệm thu...) trong dir con mà user có quyền
                SELECT DISTINCT d_child2.*, d_parent2.name AS parent_name
                FROM chat_participant cp
                JOIN chat_thread ct ON cp.thread_id = ct.id
                JOIN dir d_parent ON ct.dir_id = d_parent.id
                JOIN dir d_child2 ON d_child2.parent_id = d_parent.id
                LEFT JOIN dir d_parent2 ON d_child2.parent_id = d_parent2.id
                WHERE cp.user_id = '$user_id'
            ";
            $result = $this->executeResult($sql);
            return [
                "status" => 1,
                "msg" => $result ? "Success" : "No accessible directories",
                "data" => $result,
            ];
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }

    function GetDirCustomer_ById($dir_id, &$result)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $customer_id = $decoded->data->user_id ?? null;
            if (!$customer_id) {
                throw new Exception("Missing user ID in token");
            }

            $dir_id = $this->conn->real_escape_string($dir_id);
            $customer_id = $this->conn->real_escape_string($customer_id);

            error_log("Request: dir_id = $dir_id, customer_id = $customer_id");

            $sql = "
           WITH RECURSIVE dir_hierarchy AS (
              SELECT 
                  d.id,
                  d.parent_id,
                  d.name,
                  d.type,
                  d.level,
                  d.created_by,
                  d.created_at,
                  p.name AS parent_name
              FROM dir d
              JOIN chat_participant cp ON cp.thread_id = d.id
              LEFT JOIN dir p ON p.id = d.parent_id

              WHERE cp.user_id = '$customer_id'

              UNION ALL

              SELECT 
                  d2.id,
                  d2.parent_id,
                  d2.name,
                  d2.type,
                  d2.level,
                  d2.created_by,
                  d2.created_at,
                  p2.name AS parent_name
              FROM dir d2
              INNER JOIN dir_hierarchy dh ON d2.id = dh.parent_id
              LEFT JOIN dir p2 ON p2.id = d2.parent_id 
          )

          SELECT DISTINCT *
          FROM dir_hierarchy
          WHERE id = '$dir_id'
          LIMIT 1 ";

            error_log("SQL Query: $sql");

            $result = $this->executeResult($sql, true);
            error_log("Result: " . json_encode($result));

            if ($result) {
                return ["status" => 1, "msg" => "Success", "data" => $result];
            } else {
                error_log(
                    "Access Denied: dir_id = $dir_id, customer_id = $customer_id, SQL = $sql",
                );
                return [
                    "status" => 0,
                    "msg" => "Directory not found or access denied",
                ];
            }
        } catch (Exception $e) {
            error_log("Error: " . $e->getMessage());
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }

    function GetDirCustomer_FromLevel(&$result, $level)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Missing user ID in token");
            }

            $sql = "
            -- 1. Dir do user tạo với đúng level
            SELECT d.*, d2.name AS parent_name
            FROM dir d
            LEFT JOIN dir d2 ON d.parent_id = d2.id
            WHERE d.created_by = '$user_id' AND d.level = '$level'

            UNION

            -- 2. Dir được mời vào với đúng level
            SELECT DISTINCT d.*, d2.name AS parent_name
            FROM chat_participant cp
            JOIN chat_thread ct ON cp.thread_id = ct.id
            JOIN dir d ON ct.dir_id = d.id
            LEFT JOIN dir d2 ON d.parent_id = d2.id
            WHERE cp.user_id = '$user_id' AND d.level = '$level'

            UNION

            -- 3. Dir cha của thư mục được mời (nếu cùng level)
            SELECT DISTINCT d_parent.*, d_grand.name AS parent_name
            FROM chat_participant cp
            JOIN chat_thread ct ON cp.thread_id = ct.id
            JOIN dir d_child ON ct.dir_id = d_child.id
            JOIN dir d_parent ON d_child.parent_id = d_parent.id
            LEFT JOIN dir d_grand ON d_parent.parent_id = d_grand.id
            WHERE cp.user_id = '$user_id' AND d_parent.level = '$level'

            UNION

            -- 4. Dir con của thư mục được mời (nếu cùng level)
            SELECT DISTINCT d_child2.*, d_parent2.name AS parent_name
            FROM chat_participant cp
            JOIN chat_thread ct ON cp.thread_id = ct.id
            JOIN dir d_parent ON ct.dir_id = d_parent.id
            JOIN dir d_child2 ON d_child2.parent_id = d_parent.id
            LEFT JOIN dir d_parent2 ON d_child2.parent_id = d_parent2.id
            WHERE cp.user_id = '$user_id' AND d_child2.level = '$level'
        ";

            $result = $this->executeResult($sql);

            return [
                "status" => 1,
                "msg" => $result
                    ? "Success"
                    : "No accessible directories at level $level",
                "data" => $result,
            ];
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }

    function SendChatMessageWS($thread_id, $message, &$response)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            $response = ["status" => -1, "msg" => "Missing token"];
            return -1;
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            $thread_id = $this->conn->real_escape_string($thread_id);
            $message = trim($this->conn->real_escape_string($message));

            if (empty($message)) {
                $response = ["status" => 0, "msg" => "Empty message"];
                return -1;
            }

            // Kiểm tra quyền gửi
            $check = "SELECT id FROM chat_participant WHERE thread_id = '$thread_id' AND user_id = '$user_id'";
            $exist = $this->executeResult($check, true);
            if (!$exist) {
                $response = ["status" => 0, "msg" => "User not in thread"];
                return -1;
            }

            $sql =
                "INSERT INTO chat_message (thread_id, user_id, message, sent_at) VALUES (?, ?, ?, NOW())";
            $stmt = $this->conn->prepare($sql);
            $stmt->bind_param("iis", $thread_id, $user_id, $message);
            $stmt->execute();

            $sql_user = "SELECT name FROM user WHERE id = '$user_id'";
            $user = $this->executeResult($sql_user, true);
            $user_name = $user["name"] ?? "Unknown";

            $response = [
                "status" => 1,
                "msg" => "Message sent",
                "message" => [
                    "thread_id" => $thread_id,
                    "user_id" => $user_id,
                    "user_name" => $user_name,
                    "message" => $message,
                    "sent_at" => date("Y-m-d H:i:s"),
                ],
            ];
            return 1;
        } catch (Exception $e) {
            $response = [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
            return -1;
        }
    }
    function UploadAttachments($thread_id, &$response)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            $response = ["status" => -1, "msg" => "Missing token"];
            return -1;
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            // Kiểm tra thread có tồn tại và thuộc dir cấp 2
            $sql = "SELECT id FROM dir WHERE id = ? AND level = 2";
            $stmt = $this->conn->prepare($sql);
            $stmt->bind_param("i", $thread_id);
            $stmt->execute();
            $result = $stmt->get_result()->fetch_assoc();

            if (!$result) {
                $response = [
                    "status" => 0,
                    "msg" => "Thread không hợp lệ hoặc không thuộc cấp 2",
                ];
                return -1;
            }

            $dir_id = $result["id"];
            $uploadedFiles = [];
            $files = $_FILES["files"];
            if (!is_array($files["name"])) {
                foreach ($files as $key => $value) {
                    $files[$key] = [$value];
                }
            }
            foreach ($files["name"] as $i => $originalName) {
                $tmpPath = $files["tmp_name"][$i];
                $fileType = $files["type"][$i];
                $ext = pathinfo($originalName, PATHINFO_EXTENSION);
                $folder = __DIR__ . "/uploads/";
                if (!is_dir($folder)) {
                    mkdir($folder, 0777, true);
                }

                $savePath =
                    "uploads/" .
                    time() .
                    "_" .
                    uniqid() .
                    "_" .
                    basename($originalName);
                if (move_uploaded_file($tmpPath, $savePath)) {
                    $stmt = $this->conn->prepare(
                        "INSERT INTO attachment (dir_id, file_name, file_path, file_type, uploaded_by, uploaded_at, chat_id) VALUES (?, ?, ?, ?, ?, NOW(), NULL)",
                    );
                    $stmt->bind_param(
                        "isssi",
                        $dir_id,
                        $originalName,
                        $savePath,
                        $fileType,
                        $user_id,
                    );
                    $stmt->execute();

                    $uploadedFiles[] = [
                        "file_name" => $originalName,
                        "file_path" => $savePath,
                        "file_type" => $fileType,
                    ];
                }
            }

            $response = [
                "status" => 1,
                "msg" => "Upload thành công",
                // "uploaded" => $uploadedFiles
            ];
            return 1;
        } catch (Exception $e) {
            $response = [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
            return -1;
        }
    }
    function GetAttachmentsByThreadId($thread_id)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            // Lấy dir_id từ thread_id
            $sql = "SELECT id FROM dir WHERE id = ? AND level = 2";
            $stmt = $this->conn->prepare($sql);
            $stmt->bind_param("i", $thread_id);
            $stmt->execute();
            $result = $stmt->get_result()->fetch_assoc();

            if (!$result) {
                return [
                    "status" => -1,
                    "msg" => "Không truy xuất dữ liệu ở thư mục này",
                ];
            }

            $dir_id = $result["id"];

            // Lấy danh sách file
            $sql =
                "SELECT id, file_name, file_path, file_type, uploaded_at FROM attachment WHERE dir_id = ? ORDER BY uploaded_at DESC";
            $stmt = $this->conn->prepare($sql);
            $stmt->bind_param("i", $dir_id);
            $stmt->execute();
            $res = $stmt->get_result();

            $files = [];
            while ($row = $res->fetch_assoc()) {
                $row["file_url"] =
                    "https://crm.gtglobal.com.vn/" .
                    str_replace("\\", "/", $row["file_path"]);
                $files[] = $row;
            }

            return $files;
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }
    function GetUserFromChatThread($thread_id)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            $sql = "SELECT d.id AS dir_id
                    FROM chat_thread ct
                    INNER JOIN dir d ON ct.dir_id = d.id
                    WHERE ct.id = ?";

            $stmt = $this->conn->prepare($sql);
            $stmt->bind_param("i", $thread_id);
            $stmt->execute();
            $result = $stmt->get_result()->fetch_assoc();

            if (!$result) {
                return ["status" => -1, "msg" => "Không tìm thấy thông tin!"];
            }

            // Lấy danh sách user trong thread
            $sql = "SELECT u.id, u.name, u.phone, u.role
                    FROM chat_participant cp
                    INNER JOIN user u ON cp.user_id = u.id
                    WHERE cp.thread_id = ?";

            $stmt = $this->conn->prepare($sql);
            $stmt->bind_param("i", $thread_id);
            $stmt->execute();
            $res = $stmt->get_result();

            $users = [];
            while ($row = $res->fetch_assoc()) {
                $users[] = $row;
            }

            return $users;
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }
    function CreateProgress(
        $title,
        $description,
        $expected_completion_date,
        $dir_id,
        &$progress_id,
        &$errortext
    ) {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            $errortext = "Missing token";
            return -1;
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            // Lấy data từ POST (formData hoặc JSON)
            if ($title === null) {
                $title = $_POST["title"] ?? "";
            }
            if ($description === null) {
                $description = $_POST["description"] ?? "";
            }
            if ($expected_completion_date === null) {
                $expected_completion_date =
                    $_POST["expected_completion_date"] ?? "";
            }
            if ($dir_id === null) {
                $dir_id = $_POST["dir_id"] ?? "";
            }

            // Nếu không có trong POST, thử lấy từ JSON body
            if (empty($title) || empty($dir_id)) {
                $input = json_decode(file_get_contents("php://input"), true);
                if ($input) {
                    $title = $title ?: $input["title"] ?? "";
                    $description = $description ?: $input["description"] ?? "";
                    $expected_completion_date =
                        $expected_completion_date ?:
                        $input["expected_completion_date"] ?? "";
                    $dir_id = $dir_id ?: $input["dir_id"] ?? "";
                }
            }

            // Validate input
            if (empty($title) || empty($dir_id)) {
                $errortext =
                    "Missing required parameters: title and dir_id are required";
                return -1;
            }

            // Generate new ID
            $sql1 = "SELECT f_create_id() as newid";
            $result1 = $this->executeResult($sql1, true);
            if (empty($result1["newid"])) {
                $errortext = "Failed to generate new ID";
                return -1;
            }
            $progress_id = $result1["newid"];

            // Escape input
            $title = $this->conn->real_escape_string(trim($title));
            $description = $this->conn->real_escape_string(trim($description));
            $expected_completion_date = $this->conn->real_escape_string(
                $expected_completion_date,
            );
            $dir_id = $this->conn->real_escape_string($dir_id);

            // Kiểm tra quyền truy cập dir
            $checkAccess = "
                SELECT d.id 
                FROM dir d 
                WHERE d.id = '$dir_id' 
                AND (
                    d.created_by = '$user_id' 
                    OR EXISTS (
                        SELECT 1 FROM chat_participant cp 
                        JOIN chat_thread ct ON cp.thread_id = ct.id 
                        WHERE cp.user_id = '$user_id' AND ct.dir_id = '$dir_id'
                    )
                )
            ";

            $access = $this->executeResult($checkAccess, true);
            if (!$access) {
                $errortext = "Access denied to directory";
                return -1;
            }

            // Insert progress
            $sql =
                "INSERT INTO progress (id, title, description, expected_completion_date, created_by, dir_id) 
                    VALUES ('$progress_id', '$title', '$description', " .
                (empty($expected_completion_date)
                    ? "NULL"
                    : "'$expected_completion_date'") .
                ", '$user_id', '$dir_id')";

            $rtn = $this->execute($sql, $errortext);
            if ($rtn != 1) {
                return -1;
            }

            return 1;
        } catch (Exception $e) {
            $errortext = "Token error: " . $e->getMessage();
            return -1;
        }
    }

    function GetProgressByDirId($dir_id = null)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            // Debug: Log request info
            error_log("GetProgressByDirId called with dir_id: " . ($dir_id ?? 'null'));
            error_log("REQUEST_URI: " . $_SERVER['REQUEST_URI']);
            error_log("GET params: " . json_encode($_GET));
            error_log("POST params: " . json_encode($_POST));
            
            // Lấy dir_id từ nhiều nguồn
            if ($dir_id === null || empty($dir_id)) {
                // 1. Thử từ GET parameter trước
                $dir_id = $_GET["dir_id"] ?? "";
                
                // 2. Thử từ POST
                if (empty($dir_id)) {
                    $dir_id = $_POST["dir_id"] ?? "";
                }
                
                // 3. Thử từ URL path
                if (empty($dir_id)) {
                    $uri = $_SERVER['REQUEST_URI'];
                    $clean_uri = strtok($uri, '?'); // Remove query string
                    $path_parts = explode('/', trim($clean_uri, '/'));
                    error_log("Path parts: " . json_encode($path_parts));
                    
                    // Lấy ID từ cuối URL
                    if (count($path_parts) > 0) {
                        $last_part = end($path_parts);
                        if (is_numeric($last_part)) {
                            $dir_id = $last_part;
                        }
                    }
                }
                
                // 4. Cuối cùng thử từ JSON body
                if (empty($dir_id)) {
                    $input = json_decode(file_get_contents("php://input"), true);
                    if ($input) {
                        $dir_id = $input["dir_id"] ?? "";
                    }
                }
            }
            
            error_log("Final dir_id: " . ($dir_id ?? 'empty'));

            if (empty($dir_id)) {
                return [
                    "status" => -1,
                    "msg" => "Missing required parameter: dir_id",
                ];
            }

            $dir_id = $this->conn->real_escape_string($dir_id);

            // Kiểm tra quyền truy cập dir - giống logic GetDirCustomer_FromToken
            $checkAccess = "
                SELECT DISTINCT d.id
                FROM dir d
                WHERE d.id = '$dir_id'
                AND (
                    -- 1. User tạo dir
                    d.created_by = '$user_id'
                    
                    OR 
                    
                    -- 2. User được mời vào chat của dir này
                    EXISTS (
                        SELECT 1 FROM chat_participant cp 
                        JOIN chat_thread ct ON cp.thread_id = ct.id 
                        WHERE cp.user_id = '$user_id' AND ct.dir_id = '$dir_id'
                    )
                    
                    OR
                    
                    -- 3. User được mời vào chat của dir cha (nếu là dir con)
                    EXISTS (
                        SELECT 1 FROM chat_participant cp 
                        JOIN chat_thread ct ON cp.thread_id = ct.id 
                        JOIN dir d_parent ON ct.dir_id = d_parent.id
                        WHERE cp.user_id = '$user_id' AND d.parent_id = d_parent.id
                    )
                )
            ";

            $access = $this->executeResult($checkAccess, true);
            if (!$access) {
                return ["status" => -1, "msg" => "Không có quyền truy cập"];
            }

            // Lấy danh sách progress
            $sql = "
            SELECT 
                p.id,
                p.title,
                p.description,
                p.expected_completion_date,
                p.completion_percentage,
                p.created_by,
                p.created_at,
                p.updated_at,
                u.name AS created_by_name
            FROM progress p
            LEFT JOIN user u ON p.created_by = u.id
            WHERE p.dir_id = '$dir_id'
            ORDER BY p.created_at DESC
        ";

            $result = $this->executeResult($sql);

            return [
                "status" => 1,
                "msg" => "Success",
                "data" => $result ?: [],
            ];
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }

    function UpdateProgress(
        $progress_id,
        $completion_percentage,
        &$errortext
    ) {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            $errortext = "Missing token";
            return -1;
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            // Lấy data từ POST (formData hoặc JSON)
            if ($progress_id === null) {
                $progress_id = $_POST["progress_id"] ?? "";
            }
            if ($completion_percentage === null) {
                $completion_percentage = $_POST["completion_percentage"] ?? "";
            }

            // Nếu không có trong POST, thử lấy từ JSON body
            if (empty($progress_id) || $completion_percentage === "") {
                $input = json_decode(file_get_contents("php://input"), true);
                if ($input) {
                    $progress_id = $progress_id ?: $input["progress_id"] ?? "";
                    $completion_percentage =
                        $completion_percentage !== ""
                            ? $completion_percentage
                            : $input["completion_percentage"] ?? "";
                }
            }

            // Validate input
            if (empty($progress_id) || $completion_percentage === "") {
                $errortext =
                    "Missing required parameters: progress_id and completion_percentage are required";
                return -1;
            }

            // Validate percentage
            if ($completion_percentage < 0 || $completion_percentage > 100) {
                $errortext = "Invalid percentage value (must be 0-100)";
                return -1;
            }

            $progress_id = $this->conn->real_escape_string($progress_id);
            $completion_percentage = $this->conn->real_escape_string(
                $completion_percentage,
            );

            // Kiểm tra quyền sửa
            $checkAccess = "
            SELECT p.id 
            FROM progress p
            JOIN dir d ON p.dir_id = d.id
            WHERE p.id = '$progress_id' 
            AND (
                p.created_by = '$user_id' 
                OR d.created_by = '$user_id'
                OR EXISTS (
                    SELECT 1 FROM chat_participant cp 
                    JOIN chat_thread ct ON cp.thread_id = ct.id 
                    WHERE cp.user_id = '$user_id' AND ct.dir_id = d.id
                )
            )
        ";

            $access = $this->executeResult($checkAccess, true);
            if (!$access) {
                $errortext = "Access denied";
                return -1;
            }

            // Update percentage
            $sql = "UPDATE progress 
                SET completion_percentage = '$completion_percentage', 
                    updated_at = NOW() 
                WHERE id = '$progress_id'";

            $rtn = $this->execute($sql, $errortext);
            if ($rtn != 1) {
                return -1;
            }

            return 1;
        } catch (Exception $e) {
            $errortext = "Token error: " . $e->getMessage();
            return -1;
        }
    }

    function GetProgressById($progress_id = null)
    {
        $headers = apache_request_headers();
        $authHeader = $headers["Authorization"] ?? "";

        if (!preg_match("/Bearer\s(\S+)/", $authHeader, $matches)) {
            return ["status" => -1, "msg" => "Missing token"];
        }

        $token = $matches[1];
        $secretKey =
            "9f1b3a2c4e77aa9e6c872ba87a7c97cf59f79d65363c41b2c30b9a6877b60fa5";

        try {
            $decoded = JWT::decode($token, new Key($secretKey, "HS256"));
            $user_id = $decoded->data->user_id ?? null;
            if (!$user_id) {
                throw new Exception("Invalid token");
            }

            // Debug: Log request info
            error_log("GetProgressById called with progress_id: " . ($progress_id ?? 'null'));
            error_log("REQUEST_URI: " . $_SERVER['REQUEST_URI']);
            error_log("GET params: " . json_encode($_GET));
            error_log("POST params: " . json_encode($_POST));
            
            // Lấy progress_id từ nhiều nguồn
            if ($progress_id === null || empty($progress_id)) {
                // 1. Thử từ GET parameter trước
                $progress_id = $_GET["progress_id"] ?? "";
                
                // 2. Thử từ POST
                if (empty($progress_id)) {
                    $progress_id = $_POST["progress_id"] ?? "";
                }
                
                // 3. Thử từ URL path
                if (empty($progress_id)) {
                    $uri = $_SERVER['REQUEST_URI'];
                    $clean_uri = strtok($uri, '?'); // Remove query string
                    $path_parts = explode('/', trim($clean_uri, '/'));
                    error_log("Path parts: " . json_encode($path_parts));
                    
                    // Lấy ID từ cuối URL
                    if (count($path_parts) > 0) {
                        $last_part = end($path_parts);
                        if (is_numeric($last_part)) {
                            $progress_id = $last_part;
                        }
                    }
                }
                
                // 4. Cuối cùng thử từ JSON body
                if (empty($progress_id)) {
                    $input = json_decode(file_get_contents("php://input"), true);
                    if ($input) {
                        $progress_id = $input["progress_id"] ?? "";
                    }
                }
            }
            
            error_log("Final progress_id: " . ($progress_id ?? 'empty'));

            if (empty($progress_id)) {
                return [
                    "status" => -1,
                    "msg" => "Missing required parameter: progress_id",
                ];
            }

            $progress_id = $this->conn->real_escape_string($progress_id);

            // Lấy thông tin progress với kiểm tra quyền - giống logic GetProgressByDirId
            $sql = "
            SELECT 
                p.id,
                p.title,
                p.description,
                p.expected_completion_date,
                p.completion_percentage,
                p.created_by,
                p.created_at,
                p.updated_at,
                p.dir_id,
                u.name AS created_by_name,
                d.name AS dir_name
            FROM progress p
            LEFT JOIN user u ON p.created_by = u.id
            LEFT JOIN dir d ON p.dir_id = d.id
            WHERE p.id = '$progress_id'
            AND (
                -- 1. User tạo progress
                p.created_by = '$user_id' 
                
                OR 
                
                -- 2. User tạo dir
                d.created_by = '$user_id'
                
                OR
                
                -- 3. User được mời vào chat của dir này
                EXISTS (
                    SELECT 1 FROM chat_participant cp 
                    JOIN chat_thread ct ON cp.thread_id = ct.id 
                    WHERE cp.user_id = '$user_id' AND ct.dir_id = d.id
                )
                
                OR
                
                -- 4. User được mời vào chat của dir cha (nếu là dir con)
                EXISTS (
                    SELECT 1 FROM chat_participant cp 
                    JOIN chat_thread ct ON cp.thread_id = ct.id 
                    JOIN dir d_parent ON ct.dir_id = d_parent.id
                    WHERE cp.user_id = '$user_id' AND d.parent_id = d_parent.id
                )
            )
        ";

            $result = $this->executeResult($sql, true);

            if (!$result) {
                return [
                    "status" => -1,
                    "msg" => "Không tìm thấy tiến độ hoặc không có quyền truy cập",
                ];
            }

            return [
                "status" => 1,
                "msg" => "Success",
                "data" => $result,
            ];
        } catch (Exception $e) {
            return [
                "status" => -1,
                "msg" => "Token error",
                "error" => $e->getMessage(),
            ];
        }
    }
}
