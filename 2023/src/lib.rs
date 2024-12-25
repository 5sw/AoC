pub mod parsing;
pub mod grid;

use std::io::{self, Read};

pub fn read_input() -> String
{
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("Reading failed");

    input
}



pub fn parse_input<T, P>(parser: P) -> T
    where for<'a> P: parsing::Parser<'a, T>
{
    let mut parser = parser;
    let input = read_input();
    parser.result(&input).expect("Could not parse input")
}
