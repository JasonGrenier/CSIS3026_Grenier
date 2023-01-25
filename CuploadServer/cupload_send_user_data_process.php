<?php
include("global.php");
$errorCode = 0;
$errorMessage = "";
$username = mysqli_real_escape_string($connection, $_GET['username']);
$res = mysqli_query($connection, "select * from cupload_users where user_name = '$username'");
$row = mysqli_fetch_assoc($res);
if (mysqli_num_rows($res) == 0) {
    $errorMessage = "There was an issue logging into Cupload server.";
    $errorCode = 1;
}
$row["errorMessage"] = $errorMessage;
$row["errorCode"] = $errorCode;
echo json_encode($row);