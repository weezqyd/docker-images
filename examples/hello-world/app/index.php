<?php

use Swoole\Http\Server;
use Swoole\Http\Request;
use Swoole\Http\Response;

$port = 8080;
$server = new Swoole\HTTP\Server("0.0.0.0", $port);

$server->on("start", function(Server $server) use($port){
    echo "Swoole http server is started at http://0.0.0.0:$port\n";
});

$server->on("request", function(Request $request, Response $response){
    $response->header("Content-Type", "application/json");
    $response->end(json_encode([ 
        'message' => 'Hello world from swoole!',
        'php' => PHP_VERSION,
        'extensions' => get_loaded_extensions(),
    ]));
});
$server->start();