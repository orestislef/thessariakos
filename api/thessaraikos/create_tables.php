<?php

$servername = "localhost";
$username = "root";
$password = "orestislef";

try {
    $conn = new PDO("mysql:host=$servername", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Create the database
    $sql = "CREATE DATABASE IF NOT EXISTS thessariakos";
    $conn->exec($sql);

    // Connect to the database
    $conn->exec("use thessariakos");

    // Create users table
    $sql = "CREATE TABLE IF NOT EXISTS users (
        unique_id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        current_location_lat DOUBLE,
        current_location_lng DOUBLE,
        date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        date_changed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )";
    $conn->exec($sql);

    // Create posts table
    $sql = "CREATE TABLE IF NOT EXISTS posts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        location_lat DOUBLE,
        location_lng DOUBLE,
        from_user VARCHAR(255) NOT NULL,
        date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        isDeleted BOOLEAN DEFAULT false
    )";
    $conn->exec($sql);

    // Create info table
    $sql = "CREATE TABLE IF NOT EXISTS info (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        details TEXT,
        isDeleted BOOLEAN NOT NULL DEFAULT FALSE,
        date DATETIME NOT NULL
    )";
    $conn->exec($sql);

    echo "Database and tables created successfully!";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}

$conn = null;
?>
