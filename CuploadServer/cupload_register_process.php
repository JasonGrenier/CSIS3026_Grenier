<?php
// $connection variable is stored in global.php
include('global.php');
require 'phoneNumberFix.php';
//sample link: localhost:8888/CuploadServer/cupload_register_process.php?username=JGrenier12&firstName=Jae&lastName=Grenier&phoneNumber=774-254-2429&password=Daisies12&email=jae@gmail.com
//variable link: localhost:8888/CuploadServer/cupload_register_process.php?username=userName&firstName=firstName&lastName=lastName&phoneNumber=phoneNumber&password=password&email=email
//collect data from GET request
$firstName = mysqli_real_escape_string($connection, $_GET['firstName']);
$lastName = mysqli_real_escape_string($connection, $_GET['lastName']);
$username = mysqli_real_escape_string($connection, $_GET['username']);
$password = mysqli_real_escape_string($connection, $_GET['password']);
//hash the password before storing it into the database, after validation
$phoneNumber = mysqli_real_escape_string($connection, $_GET['phoneNumber']);
//format phone number to E164 for Twilio services
$phoneNumber = E164Formatter($phoneNumber);
//data to be sent to iPhone
$errorMessage = "";
$errorCode = 0;
//validate data in
if(strlen($firstName) < 2)
    $errorMessage .= "First name must be longer than 2 characters.\n";
if(strlen($lastName) < 2)
    $errorMessage .= "Last name must be longer than 2 characters.\n";
// 8 characters long with at least one capital letter and one number
if (!preg_match('/^(?=.*[a-z])(?=.*[A-Z]).{8,}[0-9]+$/', $password))
    $errorMessage .= "Password must be 8 characters long with at least one capital letter and one number.\n";
if(strlen($username) < 4)
    $errorMessage .= "Username must be longer than 4 characters.\n";
//E164 phone number regex validation
if (!preg_match('/^\+[1-9]\d{1,14}$/', $phoneNumber))
    $errorMessage .= "Invalid phone number.\n";
//check if username is already taken
$res = mysqli_query($connection, "select * from cupload_users where user_name = '$username'");
if (mysqli_num_rows($res) != 0) {
    $errorMessage .= "Username already taken.\n";
}
//check if username is already taken
$res = mysqli_query($connection, "select * from cupload_users where email = '$email'");
if (mysqli_num_rows($res) != 0) {
    $errorMessage .= "Email already in use.\n";
}
if($errorMessage == ""){
    //hash the password before storing into database
    $password = password_hash($password, PASSWORD_BCRYPT, ["salt" => "jlsasndajncfdjnskdkjdsoksjk"]);
    //store data in database
    mysqli_query($connection, "insert into cupload_users (first_name, last_name, user_name, pass_word, phone_number) values('$firstName', '$lastName', 
                                                                                                    '$username', '$password', '$phoneNumber')");
    //$res = mysqli_query($connection, "select * from users where username = '$username'
    // and password = '$password'");
    //establish session information
    /*$row = mysqli_fetch_assoc($res);
    //Ask if I need to include this
    $_SESSION["userid"] = intval($row["id"]);
    $_SESSION["name"] = mysqli_real_escape_string($connection, $row["first_name"]);
    session_start();*/
} else {
    $errorCode = 1;
}
/*
decode the JSON to parse for testing
$logInJSONDecoded = json_decode($logInJSON, true);
echo "Data in: \n";
echo $username . "\n";
echo $firstName . "\n";
echo $lastName . "\n";
echo $password . "\n";
echo $email . "\n";
echo $phoneNumber . "\n\n";
echo "Data out: \n";*/
//sending data out to the iphone
//$errorMessage = nl2br($errorMessage);
$registerResponse = array("errorCode" => $errorCode, "errorMessage" => $errorMessage);
header("Content-Type: application/json; charset=utf-8");
$registerJSON = json_encode($registerResponse, true);
echo $registerJSON;