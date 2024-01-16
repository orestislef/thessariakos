<?php
header('Content-Type: application/json');

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

// Handle POST request for creating a user or a post
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    if ($_POST['action'] === 'create_user') {
        createUser();
    } elseif ($_POST['action'] === 'create_post') {
        createPost();
    } elseif ($_POST['action'] === 'update_user_location') {
        updateLocation();
    }
}

// Handle GET request for retrieving posts
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['action'])) {
    if ($_GET['action'] === 'get_posts') {
        getPosts();
    } elseif ($_GET['action'] === 'get_info') {
        getInfo();
    }
}

function createUser() {
    global $conn;

    $unique_id = $_POST['unique_id'];
    $name = $_POST['name'];
    $current_location_lat = $_POST['current_location_lat'];
    $current_location_lng = $_POST['current_location_lng'];

    // Check if the user already exists
    $stmt = $conn->prepare("SELECT * FROM users WHERE unique_id = ?");
    $stmt->execute([$unique_id]);
    $existingUser = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($existingUser) {
        // User exists, update location and date_changed
        $stmt = $conn->prepare("UPDATE users SET current_location_lat = ?, current_location_lng = ?, date_changed = CURRENT_TIMESTAMP WHERE unique_id = ?");
        if ($stmt->execute([$current_location_lat, $current_location_lng, $unique_id])) {
            echo json_encode(['status' => 'success', 'message' => 'User location updated successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error updating user location']);
        }
    } else {
        // User does not exist, create a new user
        $stmt = $conn->prepare("INSERT INTO users (unique_id, name, current_location_lat, current_location_lng) VALUES (?, ?, ?, ?)");
        if ($stmt->execute([$unique_id, $name, $current_location_lat, $current_location_lng])) {
            echo json_encode(['status' => 'success', 'message' => 'User created successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error creating user']);
        }
    }
}


function createPost() {
    global $conn;

    $title = $_POST['title'];
    $description = $_POST['description'];
    $location_lat = $_POST['location_lat'];
    $location_lng = $_POST['location_lng'];
    $from_user = $_POST['from_user'];
    $date_created = date("Y-m-d H:i:s");
    $isDeleted = false;

    $stmt = $conn->prepare("INSERT INTO posts (title, description, location_lat, location_lng, from_user, date_created, isDeleted) VALUES (?, ?, ?, ?, ?, ?, ?)");
    if ($stmt->execute([$title, $description, $location_lat, $location_lng, $from_user, $date_created, $isDeleted])) {
        echo json_encode(['status' => 'success', 'message' => 'Post created successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error creating post']);
    }
}

function updateLocation() {
    global $conn;

    $unique_id = $_POST['unique_id'];
    $current_location_lat = $_POST['current_location_lat'];
    $current_location_lng = $_POST['current_location_lng'];
    $date_changed = date("Y-m-d H:i:s");

    $stmt = $conn->prepare("UPDATE users SET current_location_lat = ?, current_location_lng = ?, date_changed = ? WHERE unique_id = ?");
    if ($stmt->execute([$current_location_lat, $current_location_lng, $date_changed, $unique_id])) {
        echo json_encode(['status' => 'success', 'message' => 'User location updated successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error updating user location']);
    }
}

function getPosts() {
    global $conn;

    $stmt = $conn->query("SELECT * FROM posts");
    $posts = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if ($posts !== false) {
        echo json_encode(['status' => 'success', 'posts' => $posts]);
    } else {
        echo json_encode(['status' => 'success', 'posts' => []]); // Return empty list if no posts
    }
}

function getInfo() {
    global $conn;

    $stmt = $conn->query("SELECT * FROM info");
    $info = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if ($info !== false) {
        echo json_encode(['status' => 'success', 'info' => $info]);
    } else {
        echo json_encode(['status' => 'success', 'info' => []]); // Return empty list if no info
    }
}
?>
