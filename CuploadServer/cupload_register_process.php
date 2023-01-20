<?php
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
$email = mysqli_real_escape_string($connection, $_GET['email']);
//data to be sent to iPhone
$errorMessage = "";
$errorCode = 0;
//validate data in
if(strlen($firstName) < 2)
    $errorMessage .= "First name must be longer than 2 characters. ";
if(strlen($lastName) < 2)
    $errorMessage .= "Last name must be longer than 2 characters. ";
if (!preg_match('/^(?=.*[a-z])(?=.*[A-Z]).{8,}[0-9]+$/', $password))
    $errorMessage .= "Password must be 8 characters long with at least one capital letter and one number. ";
if(strlen($username) < 4)
    $errorMessage .= "Username must be longer than 4 characters. ";
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errorMessage .= "Invalid email format. ";
}
//E164 phone number regex validation
if (!preg_match('/^\+[1-9]\d{1,14}$/', $phoneNumber))
    $errorMessage .= "Invalid phone number. ";
//check if username is already taken
$res = mysqli_query($connection, "select * from cupload_users where user_name = '$username'");
if (mysqli_num_rows($res) != 0) {
    $errorMessage .= "Username already taken. ";
}
//check if username is already taken
$res = mysqli_query($connection, "select * from cupload_users where email = '$email'");
if (mysqli_num_rows($res) != 0) {
    $errorMessage .= "Email already in use. ";
}
if($errorMessage == ""){
    $errorCode = 0;
    //hash the password before storing into database
    $password = password_hash($password, PASSWORD_BCRYPT, ["salt" => "jlsasndajncfdjnskdkjdsoksjk"]);
    //store data in database
    mysqli_query($connection, "insert into cupload_users (first_name, last_name, user_name, pass_word, email, phone_number) values('$firstName', '$lastName', 
                                                                                                    '$username', '$password', '$email', '$phoneNumber')");
    $res = mysqli_query($connection, "select * from users where username = '$username' 
and password = '$password'");
    //establish session information
    $row = mysqli_fetch_assoc($res);
    $_SESSION["userid"] = intval($row["id"]);
    $_SESSION["name"] = mysqli_real_escape_string($connection, $row["first_name"]);
    echo $_SESSION["name"];
    session_start();
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
$registerResponse = array("errorCode" => $errorCode, "errorMessage" => $errorMessage);
header("Content-Type: application/json");
$registerJSON = json_encode($registerResponse, true);
echo $registerJSON;