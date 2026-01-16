<?php
include 'koneksi.php';

$user_id = $_POST['user_id'];
$donor_date = $_POST['donor_date'];
$blood_type = $_POST['blood_type'];

$query = "INSERT INTO donor_history (user_id, donor_date, blood_type)
          VALUES ('$user_id', '$donor_date', '$blood_type')";

if (mysqli_query($koneksi, $query)) {
    echo json_encode([
        "status" => "success",
        "message" => "Donor berhasil ditambahkan"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Gagal menambahkan donor"
    ]);
}
