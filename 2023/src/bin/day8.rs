use std::collections::HashMap;

mod parsing {
use nom::{Parser, sequence::{tuple, terminated}, character::complete::{newline, one_of}, multi::{many_till, separated_list0}, combinator::{map}, bytes::complete::{take, tag}};
use std::collections::HashMap;

fn instructions(input: &str) -> aoc::parsing::Result<Vec<char>> {
    map(many_till(one_of("LR"), newline), |(result,_)| result).parse(input)
}

fn node(input: &str) -> aoc::parsing::Result<&str> {
    take(3usize).parse(input)
}

fn map_line(input: &str) -> aoc::parsing::Result<(&str, &str, &str)> {
    tuple((
        terminated(node, tag(" = (")),
        terminated(node, tag(", ")),
        terminated(node, tag(")"))
    )).parse(input)
}

fn parse_map(input: &str) -> aoc::parsing::Result<HashMap<&str, (&str, &str)>> {
    map(separated_list0(newline, map_line), |list| {
        let mut result = HashMap::with_capacity(list.len());

        for (node, left, right) in list {
            result.insert(node, (left, right));
        }

        result
    }).parse(input)
}

pub fn input(input: &str) -> aoc::parsing::Result<(Vec<char>, HashMap<&str, (&str, &str)>)> {
    tuple((
        terminated(instructions, newline),
        parse_map
    )).parse(input)
}
}

type Map<'a> = HashMap<&'a str, (&'a str, &'a str)>;

struct Camel<'a> {
    position: &'a str,
    map: &'a Map<'a>
}

impl Camel<'_> {
    fn new<'a>(position: &'a str, map: &'a Map) -> Camel<'a> {
        assert!(position.len() == 3);
        Camel { position, map }
    }

    fn go(&mut self, direction: char) {
        let (left, right) = self.map.get(self.position).expect(&format!("Position {} not in map", self.position));

        self.position = match direction {
            'L' => left,
            'R' => right,
            _ => panic!("Invalid direction {direction}")
        }
    }

    fn at_goal(&self) -> bool {
        self.position.chars().nth(2).unwrap() == 'Z'
    }
}

fn main() {
    let input = aoc::read_input();
    let (_, (instructions, map)) = parsing::input(&input).expect("Failed to parse");

    let mut iter = instructions.iter().cycle();

    let mut camel = Camel::new("AAA", &map);
    let mut steps = 0;
    while camel.position != "ZZZ" {
        camel.go(*iter.next().unwrap());
        steps += 1;
    }

    println!("Part 1: {steps}");

    let mut camels: Vec<_> = map.keys().filter_map(|key| if key.chars().last().unwrap() == 'A' {
        Some(Camel::new(key, &map))
    } else {
        None
    }).collect();

    println!("{:?}", camels.iter().map(|x| x.position).collect::<Vec<_>>());

    let mut iter = instructions.iter().cycle();

    let mut steps = 0;
    while !camels.iter().all(Camel::at_goal) {
        let direction = *iter.next().unwrap();
        for camel in camels.iter_mut() {
            camel.go(direction);
        }
        steps += 1;
    }

    println!("Part 2: {steps}");

}