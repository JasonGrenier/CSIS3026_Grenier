<?php
include('global.php');
$errorMessage = "";
$errorCode = 0;
//sample link: localhost:8888/CuploadServer/cupload_login_process.php?username=JGrenier12&password=Daisies12
$username = mysqli_real_escape_string($connection, $_GET["username"]);
$password = password_hash($_GET["password"], PASSWORD_BCRYPT, ["salt" => "jlsasndajncfdjnskdkjdsoksjk"]);
$res = mysqli_query($connection, "select * from cupload_users where user_name = '$username' 
and pass_word = '$password'");

if (mysqli_num_rows($res) == 0) {
    $errorCode = 1;
    $errorMessage = "Invalid log in credentials.";
} else {
    $errorMessage = "Logged in successfully.";
    $row = mysqli_fetch_assoc($res);
    $_SESSION["userid"] = $row["id"];
    $_SESSION["name"] = $row["first_name"];
}
//sending data out to the iphone
$registerResponse = array("errorCode" => $errorCode, "errorMessage" => $errorMessage);
header("Content-Type: application/json");
$logInJSON = json_encode($registerResponse, true);
echo $logInJSON;
