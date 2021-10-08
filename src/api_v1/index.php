<?php

if ($_SERVER["REQUEST_URI"] == '/v1/Debug') {
    echo file_get_contents("/tmp/cron.log");
} else {
    echo json_encode($_ENV);
}

