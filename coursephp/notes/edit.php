<?php
include "../connect.php";

$noteid = filterRequest("id");
$title  = filterRequest("title");
$content = filterRequest("content");
$imagename = filterRequest("imagename");

// Check if a new image is uploaded
if (isset($_FILES["imagename"]) && $_FILES["imagename"]["error"] == 0) {
    // Delete the old image if there is a valid file being uploaded
    if (!empty($imagename)) {
        deleteFile("../upload", $imagename);
    }
    // Upload the new image
    $imagename = imageUploade("imagename");
} else {
    // If no new image, keep the old image in the database
    $stmt = $con->prepare("SELECT notes_image FROM notes WHERE notes_id = ?");
    $stmt->execute(array($noteid));
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $imagename = $row['notes_image'];
}

$stmt = $con->prepare("UPDATE `notes` SET `notes_title`= ?,`notes_content`= ?, `notes_image` = ? WHERE notes_id = ?");
$stmt->execute(array($title, $content, $imagename, $noteid));

$count = $stmt->rowCount();

if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "fail"));
}
