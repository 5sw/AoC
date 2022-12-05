<?php

$input = explode("\n", file_get_contents('day5.input'));

$empty = array_search('', $input, true);

$stackDescriptions = array_slice($input, 0, $empty - 1);
$commands = array_slice($input, $empty + 1);


$numbers = array_filter(explode(' ', $input[$empty - 1]));

$stacks = [];
foreach($numbers as $number) {
    $stacks[$number] = [];
}

foreach ($stackDescriptions as $line) {
    $items = array_map(fn ($str) => trim($str, '[] '), str_split($line, 4));
    $crates = array_combine($numbers, $items);
    foreach ($crates as $stack => $crate) {
        if ($crate !== '') {
            array_unshift($stacks[$stack], $crate);
        }
    }
}

foreach ($commands as $command) {
    preg_match('/move (\d+) from (\d+) to (\d+)/', $command, $matches);
    [$x, $count, $from, $to] = $matches;
    for ($i = 0; $i < $count; $i++) {
        array_push($stacks[$to], array_pop($stacks[$from]));
    }
}

$result = implode('', array_map('end', $stacks));
echo 'Top crates: ' . $result;