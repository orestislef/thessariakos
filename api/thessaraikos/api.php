<?php
header('Content-Type: application/json');

// Include the database configuration
include('db_config.php');

// Handle POST request for creating a user or a post
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    if ($_POST['action'] === 'create_user') {
        createUser();
    } elseif ($_POST['action'] === 'create_post') {
        createPost();
    } elseif ($_POST['action'] === 'update_user_location') {
        updateLocation();
    } elseif ($_POST['action'] === 'delete_post') {
        deletePost();
	}
}

// Handle GET request for retrieving posts
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['action'])) {
    if ($_GET['action'] === 'get_posts') {
		if (isset($_GET['last_id'])){
			getPostsByLastID();
		}else{
			getPosts();
		}
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

    // Fetch and sanitize inputs
    $title = filter_input(INPUT_POST, 'title', FILTER_SANITIZE_STRING);
    $description = filter_input(INPUT_POST, 'description', FILTER_SANITIZE_STRING);
    $location_lat = filter_input(INPUT_POST, 'location_lat', FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
    $location_lng = filter_input(INPUT_POST, 'location_lng', FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
    $from_user = filter_input(INPUT_POST, 'from_user', FILTER_SANITIZE_STRING);

    // Check if from_user exists in the users table
    $stmtCheckUser = $conn->prepare("SELECT * FROM users WHERE unique_id = ?");
    $stmtCheckUser->execute([$from_user]);
    $existingUser = $stmtCheckUser->fetch(PDO::FETCH_ASSOC);

    if ($existingUser) {
        // Create a DateTime object and set it to the current time in UTC
        $date_created_utc = new DateTime('now', new DateTimeZone('Europe/Athens'));

        // Format the date as needed for the database
        $date_created = $date_created_utc->format("Y-m-d H:i:s");

        $isDeleted = 0; // Use 0 for false in database context

        $stmt = $conn->prepare("INSERT INTO posts (title, description, location_lat, location_lng, from_user, date_created, isDeleted) VALUES (?, ?, ?, ?, ?, ?, ?)");

        if ($stmt->execute([$title, $description, $location_lat, $location_lng, $from_user, $date_created, $isDeleted])) {
            echo json_encode(['status' => 'success', 'message' => 'Post created successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error creating post']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid from_user. User does not exist']);
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

function getPostsByLastID() {
	global $conn;

	$lastId = $_GET['last_id'];
	
	$stmt = $conn->query("SELECT * FROM posts WHERE id > $lastId");
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

function deletePost(){
    global $conn;

    $isDeleted = 1;
    $id = $_POST['id'];

    $stmt = $conn->prepare("UPDATE posts SET isDeleted = ? WHERE id = ?");
    if ($stmt->execute([$isDeleted, $id])) {
        echo json_encode(['status' => 'success', 'message' => 'Post deleted successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error deleting post']);
    }
}

?>
