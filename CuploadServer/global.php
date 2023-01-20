<?php
//establishing connection
$connection = mysqli_connect("localhost", "root", "root", "cupload") or die("Unable to connect to database");
session_start();
