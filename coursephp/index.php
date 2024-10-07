<?php

include "connect.php";

$stmt = $con->prepare("INSERT INTO `users`( `username`, `email`) VALUES ('rita','rita@gmail.com')");
$stmt->execute();

$count = $stmt->rowCount();
if ($count > 0) {
    echo "succesed";
} else {
    echo "failed";
}
