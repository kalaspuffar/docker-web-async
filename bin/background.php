<?php
/*
$envFile = file_get_contents("/container.env");

$allowedVariables = array('USERNAME', 'PASSWORD');

$envArray = preg_split("/\r\n|\n|\r/", $envFile);
foreach ($envArray as $envVal) {
    $keyVal = explode("=", $envVal);
    if (in_array($keyVal[0], $allowedVariables)) {
        $_ENV[$keyVal[0]] = $keyVal[1];
    }
}
*/

echo json_encode($_ENV);
