<?php
include "koneksi.php";

$email = $_POST['email'];
$query = mysqli_query($conn, "SELECT name, email FROM users WHERE email='$email'");
$data = mysqli_fetch_assoc($query);

if ($data) {
  echo json_encode([
    "status" => "success",
    "data" => $data
  ]);
} else {
  echo json_encode(["status" => "failed"]);
}
