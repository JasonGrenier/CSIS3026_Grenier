<?php
function E164Formatter($unformattedPhone) {
    $unformattedPhone = str_replace(' ', '', $unformattedPhone);
    if (strlen($unformattedPhone) > 15) {
        $unformattedPhone = substr($unformattedPhone, 0, 10) . preg_replace('/[\/a-z-]0.+$/', '', substr($unformattedPhone, 10));
    }
    $unformattedPhone = preg_replace('/[^0-9]/', '', $unformattedPhone);
    $unformattedPhone = preg_replace('/^(00)/', '+', $unformattedPhone);
    $unformattedPhone = preg_replace('/^(0)/', '+49', $unformattedPhone);
    $unformattedPhone = preg_replace('/^([1-9])/', '+\1', $unformattedPhone);

    if (substr($unformattedPhone, 0, 1) !== '+' || strlen($unformattedPhone) < 8) {
        $unformattedPhone = null;
    }
    return substr($unformattedPhone, 0, 16);
}