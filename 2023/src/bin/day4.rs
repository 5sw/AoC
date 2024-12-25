use std::collections::HashSet;

#[derive(Debug)]
struct Card {
    number: usize,
    winning: HashSet<usize>,
    numbers: Vec<usize>
}

impl Card {
    fn new(number: usize, winning: HashSet<usize>, numbers: Vec<usize>) -> Self { Self { number, winning, numbers } }

    fn winning_numbers(&self) -> usize {
        self.numbers.iter().filter(|x| self.winning.contains(x)).count()
    }

    fn score(&self) -> usize {
        let winners = self.winning_numbers();
        if winners > 0 {
            2usize.pow((winners - 1).try_into().unwrap())
        } else {
            0
        }
    }
}

mod parser {
    use std::collections::{HashSet, hash_map::RandomState};

    use nom::{IResult, multi::{many0, separated_list0}, Parser, sequence::{tuple, preceded}, bytes::complete::tag, character::complete::{multispace0, digit1}, combinator::map_res};
    use nom::character::complete::multispace1;

    use crate::Card;

    fn number(input: &str) -> IResult<&str, usize> {
        map_res(digit1, str::parse)(input)
    }

    fn list(input: &str) -> IResult<&str, Vec<usize>> {
        preceded(multispace0, separated_list0(multispace1, number)).parse(input)
    }

    fn card(input: &str) -> IResult<&str, Card> {
        tuple((
            tag("Card"),
            preceded(multispace1, number),
            tag(":"),
            list
                .map(|list| HashSet::<usize, RandomState>::from_iter(list.iter().map(|x| *x))),
            preceded(multispace0, tag("|")),
            list,
            multispace0
        )).map(|(_, card_index, _, winning, _, given, _)| Card::new(card_index, winning, given))
        .parse(input)
    }

    pub fn input(input: &str) -> IResult<&str, Vec<Card>> {
        many0(card).parse(input)
    }
}

fn main() {
    let data = aoc::read_input();
    let cards = parser::input(&data).expect("Parsing failed").1;

    let part1 = cards.into_iter().fold(0, |a, b| a + b.score());
    println!("Part 1: {part1}");
}