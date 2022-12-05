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

abstract class CrateMover {
    public function __construct(protected array $stacks) {}
    
    protected abstract function move(int $count, string $from, string $to);
    
    public function run(array $commands): string {
        foreach ($commands as $command) {
            preg_match('/move (\d+) from (\d+) to (\d+)/', $command, $matches);
            [$x, $count, $from, $to] = $matches;
            $this->move((int)$count, $from, $to);
        }

        return implode('', array_map('end', $this->stacks));
    }
}

class CrateMover9000 extends CrateMover {
    protected function move(int $count, string $from, string $to): void {
        for ($i = 0; $i < $count; $i++) {
            array_push($this->stacks[$to], array_pop($this->stacks[$from]));
        }        
    }
}

class CrateMover9001 extends CrateMover {
    protected function move(int $count, string $from, string $to): void {
        $moved = array_splice($this->stacks[$from], -$count);
        $this->stacks[$to] = array_merge($this->stacks[$to], $moved);
    }
}

$mover = new CrateMover9000($stacks);
echo 'Part 1: Top crates: ' . $mover->run($commands) . PHP_EOL;

$mover = new CrateMover9001($stacks);
echo 'Part 2: Top crates: ' . $mover->run($commands) . PHP_EOL;
