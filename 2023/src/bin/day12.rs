use std::iter::zip;
use aoc::{parsing, read_input};
use nom::{character::complete::{space1, newline}, Parser, bytes::complete::{take_while1, tag}, sequence::{tuple, terminated}, multi::{separated_list0, many0}};
use aoc::parsing::number;

fn matches(string: &str, groups: &Vec<usize>) -> bool {
    let parts = string.split('.')
        .filter(|s| !s.is_empty())
        .map(|s| s.chars().filter(|ch| *ch == '#').count());

    let group_iter = groups.iter();

    let all_equal = zip(parts.clone(), group_iter).all(|(a, b)| a == *b);
    parts.count() == groups.len() && all_equal
}

fn combinations(string: &str, groups: &Vec<usize>) -> usize {
    if let Some(index) = string.find('?') {
        let first = &string[..index];
        let rest = &string[(index + 1)..];

        let mut a = first.to_owned();
        a.push('.');
        a.push_str(rest);

        let mut b = first.to_owned();
        b.push('#');
        b.push_str(rest);

        combinations(&a, groups) + combinations(&b, groups)
    } else if matches(string, groups) {
        1
    } else {
        0
    }
}

fn springs<'a>(input: &'a str) -> parsing::Result<'a, &'a str> {
    take_while1(|ch| ch == '#' || ch == '.' || ch == '?').parse(input)
}

fn line<'a>(input: &'a str) -> parsing::Result<'a, (&'a str, Vec<usize>)> {
    tuple((
        terminated(springs, space1),
        separated_list0(tag(","), number)
    )).parse(input)
}

fn main() {
    let input = read_input();
    let (_, input) = separated_list0(newline, line).parse(&input).expect("Cannot parse input");
    let mut sum: usize = 0;
    for (str, groups) in input {
        sum += combinations(&str, &groups);
    }
    println!("Part 1: {sum}");
}
