<?php

use Depotwarehouse\Jeopardy\Board\BoardFactory;
use Depotwarehouse\Jeopardy\Server;
use React\EventLoop\Factory;
use React\Socket\ConnectionException;

require 'vendor/autoload.php';

$question_filename = isset($argv[1]) ? $argv[1] : "questions";

$server = new Server(Factory::create());

try {
    $boardFactory = new BoardFactory($question_filename);
    $server->run($boardFactory);
} catch (ConnectionException $exception) {
    echo "Error occurred: " . get_class($exception) . "\n";
    echo $exception->getMessage();
    die();
}

