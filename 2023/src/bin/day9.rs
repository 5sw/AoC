use aoc::read_input;
use aoc::{parse_input, parsing::numbers};
use nom::multi::many0;
use nom::Parser;

fn next_element(list: &Vec<isize>) -> isize 
{
    if list.iter().all(|x| *x == 0) {
        0
    } else {
        let last = list.last().expect("Cannot use with empty list");
        last + next_element(&differences(&list))
    }
}

fn previous_element(list: &Vec<isize>) -> isize 
{
    if list.iter().all(|x| *x == 0) {
        0
    } else {
        let first = list.first().expect("Cannot use with empty list");
        first - previous_element(&differences(&list))
    }
}

fn differences(list: &Vec<isize>) -> Vec<isize>
{
    use itertools::Itertools;
    list.iter().tuple_windows().map(|(a, b)| b - a).collect()
}

fn main() {
    let input = read_input();
    let (_, lists) = many0(numbers).parse(&input).unwrap();


    let part1 = lists.iter().fold(0, |a, b| a + next_element(b));
    println!("Part 1: {part1}");

    let part2 = lists.iter().fold(0, |a, b| a + previous_element(b));
    println!("Part 2: {part2}");
}
