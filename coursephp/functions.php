<?php

define("MB", 1048576);

function filterRequest($requestname)
{
    return isset($_POST[$requestname]) ? htmlspecialchars(strip_tags($_POST[$requestname])) : "";
}

function imageUploade($imageRequest)
{
    global $msgError;

    if (!isset($_FILES[$imageRequest]) || $_FILES[$imageRequest]['error'] != 0) {
        $msgError[] = "File upload failed. Please check the file and try again.";
        return "fail";
    }

    $imagename = rand(1000, 10000) . $_FILES[$imageRequest]['name'];
    $imagetmp = $_FILES[$imageRequest]['tmp_name'];
    $imagesize = $_FILES[$imageRequest]['size'];
    $allowExt = array("jpg", "png", "gif", "mp3", "pdf");
    $strToArray = explode(".", $imagename);
    $ext = end($strToArray);
    $ext = strtolower($ext);

    // Validate the extension and size
    if (!in_array($ext, $allowExt)) {
        $msgError[] = "Extension not allowed";
    }
    if ($imagesize > 10 * MB) {
        $msgError[] = "Size bigger than 10MB";
    }

    // If there are no errors, proceed with file upload
    if (empty($msgError)) {
        $uploadDir = __DIR__ . "/upload/";
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        move_uploaded_file($imagetmp, $uploadDir . $imagename);
        return $imagename;
    } else {
        return "fail";
    }
}

function deleteFile($dir, $imagename)
{
    if (!empty($imagename) && file_exists($dir . "/" . $imagename)) {
        unlink($dir . "/" . $imagename);
    } else {
        echo "File does not exist or no image provided.";
    }
}
function checkAuthenticate()
{
    if (isset($_SERVER['PHP_AUTH_USER'])  && isset($_SERVER['PHP_AUTH_PW'])) {

        if ($_SERVER['PHP_AUTH_USER'] != "josh" ||  $_SERVER['PHP_AUTH_PW'] != "josh12345") {
            header('WWW-Authenticate: Basic realm="My Realm"');
            header('HTTP/1.0 401 Unauthorized');
            echo 'Page Not Found';
            exit;
        }
    } else {
        exit;
    }
}
