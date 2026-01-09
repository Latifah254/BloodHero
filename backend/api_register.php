<?php
include 'koneksi.php';

if (
    isset($_POST['name']) &&
    isset($_POST['email']) &&
    isset($_POST['password'])
) {
    $name     = $_POST['name'];
    $email    = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $query = "INSERT INTO users (name, email, password)
              VALUES ('$name', '$email', '$password')";

    if (mysqli_query($conn, $query)) {
        echo json_encode([
            "status" => "success",
            "message" => "Register berhasil"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Register gagal"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Data tidak lengkap"
    ]);
}
?>
