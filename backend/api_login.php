<?php
include 'koneksi.php';

if (
    isset($_POST['email']) &&
    isset($_POST['password'])
) {
    $email    = $_POST['email'];
    $password = $_POST['password'];

    $query = "SELECT * FROM users WHERE email='$email'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $user = mysqli_fetch_assoc($result);

        if (password_verify($password, $user['password'])) {
            echo json_encode([
                "status" => "success",
                "message" => "Login berhasil",
                "user" => [
                    "id" => $user['id'],
                    "name" => $user['name'],
                    "email" => $user['email']
                ]
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Password salah"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Email tidak ditemukan"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Data tidak lengkap"
    ]);
}
?>
