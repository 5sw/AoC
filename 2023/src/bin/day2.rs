
use std::{io, cmp::max};
use std::io::Read;

use nom::{
    branch::alt, 
    bytes::complete::tag, 
    IResult, 
    Parser, 
    multi::separated_list0, 
    sequence::{separated_pair, tuple}, 
    combinator::map_res, 
    character::{streaming::digit1, complete::line_ending}, 
};

#[derive(Debug)]
struct Reveal {
    red: usize, 
    green: usize, 
    blue: usize
}

#[derive(Debug)]
struct Game {
    id: usize,
    reveals: Vec<Reveal>
}

impl Game {
    fn new(id: usize, reveals: Vec<Reveal>) -> Game {
        Game { id, reveals }
    }

    fn is_valid(&self) -> bool {
        self.reveals.iter().all(|reveal| reveal.is_valid())
    }

    fn min_cubes(&self) -> Reveal {
        self.reveals.iter().fold(Reveal::new(), |acc, reveal| {
            Reveal {
                red: max(acc.red, reveal.red),
                green: max(acc.green, reveal.green),
                blue: max(acc.blue, reveal.blue)
            }
        })
    }
}

impl Reveal {
    fn new() -> Reveal {
        Reveal { red: 0, green: 0, blue: 0 }
    }

    fn with_red(&self, red: usize) -> Reveal {
        Reveal { red: self.red + red, green: self.green, blue: self.blue } 
    }

    fn with_green(&self, green: usize) -> Reveal {
        Reveal { red: self.red, green: self.green + green, blue: self.blue }
    }

    fn with_blue(&self, blue: usize) -> Reveal {
        Reveal { red: self.red, green: self.green, blue: self.blue + blue }
    }

    fn with(&self, color: Color, count: usize) -> Reveal {
        match color {
            Color::Red => self.with_red(count),
            Color::Green => self.with_green(count),
            Color::Blue => self.with_blue(count),
        }
    }

    fn is_valid(&self) -> bool {
        self.red <= 12 && self.green <= 13 && self.blue <= 14
    }

    fn power(&self) -> usize {
        self.red * self.green * self.blue
    }
}

#[derive(Clone, Copy)]
enum Color {
    Red,
    Green,
    Blue
}

impl From<&str> for Color {
    fn from(value: &str) -> Self {
        match  value {
            "red" => Color::Red,
            "blue" => Color::Blue,
            "green" => Color::Green,
            _ => panic!("Invalid color")
        }
    }
}

fn color(input: &str) -> IResult<&str, Color> {
    Parser::into(alt((
        tag("red"),
        tag("green"),
        tag("blue")
    ))).parse(input)
}

fn number(input: &str) -> IResult<&str, usize> {
    map_res(digit1, str::parse).parse(input)
}

fn color_count(input: &str) -> IResult<&str, (usize, Color)> {
    separated_pair(
        number,
        tag(" "), 
        color
    ).parse(input)
}

fn reveal(input: &str) -> IResult<&str, Reveal> {
    separated_list0(tag(", "), color_count)
        .map(|list|  {
            list.iter().fold(Reveal::new(), |acc, (count, color)| {
                acc.with(*color, *count)
            })
        })
        .parse(input)
}

fn reveals(input: &str) -> IResult<&str, Vec<Reveal>> {
    separated_list0(tag("; "), reveal).parse(input)
}

fn game(input: &str) -> IResult<&str, Game> {
    tuple((
        tag("Game "),
        number,
        tag(": "),
        reveals,
    ))
    .map(|(_, id, _, reveals)| Game::new(id, reveals))
    .parse(input)
}

fn input_file(input: &str) -> IResult<&str, Vec<Game>> {
    separated_list0(line_ending, game).parse(input)
}


fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("Reading failed");

    let (_, games) = input_file(input.as_str()).expect("Parsing failed");
    

    let part1 = games.iter().filter(|game| game.is_valid()).fold(0, |acc, game| acc + game.id);
    println!("Part 1: {part1}");

    let part2 = games.iter().fold(0, |acc, game| acc + game.min_cubes().power());
    println!("Part 2: {part2}");
}
