<?php
    header('Content-Type: application/json');

    echo json_encode([
        "message" => "Hello, world",
        "php" => phpversion(),
        "query" => $_GET,
        "headers" => getallheaders(),
    ]);
?>