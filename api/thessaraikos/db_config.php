<?php
// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "thessariakos";

// Create connection
$conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);

// Check connection
if (!$conn) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->errorInfo()]));
}
?>
