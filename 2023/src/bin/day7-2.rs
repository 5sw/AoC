use std::{error::Error, collections::HashMap, cmp::Ordering};

#[derive(PartialEq, Eq, PartialOrd, Ord, Debug, Clone, Copy, Hash)]
enum Label {
    J,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    T,
    Q,
    K,
    A
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd)]
struct Hand {
    cards: [Label; 5]
}

struct WrongCardCount;

impl TryFrom<Vec<Label>> for Hand {
    type Error = WrongCardCount;
    fn try_from(value: Vec<Label>) -> Result<Self, Self::Error> {
        let cards: [Label; 5] = value.try_into().map_err(|_| WrongCardCount)?;
        Ok(Hand { cards })
    }
}

mod parser {
    use nom::{character::complete::{one_of, multispace1, newline}, Parser, combinator::{map_opt, map_res}, multi::{count, separated_list0}, sequence::{preceded, tuple}};
    use aoc::parsing::number;
    
    fn label(input: &str) -> aoc::parsing::Result<crate::Label> {
        map_opt(one_of("23456789TJQKA"), crate::Label::from_char).parse(input)
    }
    
    fn hand(input: &str) -> aoc::parsing::Result<crate::Hand> {
        map_res(count(label, 5), |vec| vec.try_into()).parse(input)        
    }

    fn line(input: &str) -> aoc::parsing::Result<(crate::Hand, usize)> {
        tuple((
            hand,
            preceded(multispace1, number)
        )).parse(input)
    }

    pub fn input(input: &str) -> aoc::parsing::Result<Vec<(crate::Hand, usize)>> {
        separated_list0(newline, line).parse(input)
    }
}

impl Label {
    fn from_char(ch: char) -> Option<Label> {
        Some(match ch {
            '2' => Label::Two,
            '3' => Label::Three,
            '4' => Label::Four,
            '5' => Label::Five,
            '6' => Label::Six,
            '7' => Label::Seven,
            '8' => Label::Eight,
            '9' => Label::Nine,
            'T' => Label::T,
            'J' => Label::J,
            'Q' => Label::Q,
            'K' => Label::K,
            'A' => Label::A,
            _ => return None
        })
    }
}

impl Hand {
    fn counts(&self) -> (Vec<usize>, usize) {
        let mut result: HashMap<Label, usize> = HashMap::new();
        for card in self.cards {
            *result.entry(card).or_insert(0) += 1;
        }
        let jokers = result.remove(&Label::J).unwrap_or(0);
        
        let mut values: Vec<usize> = result.values().map(|x| *x).collect();
        values.sort_by(|a, b| b.cmp(a));
        return (values, jokers);
    }
    
    fn value(&self) -> Value {
        let (counts, mut jokers) = self.counts();
        let mut counts = counts.iter();

        let first = counts.next().unwrap_or(&0);
        if first + jokers >= 5 {
            return Value::Five;
        }

        if first + jokers >= 4 {
            return Value::Four;
        }

        if first + jokers >= 3 {
            jokers -= 3 - first;
            
            let next = *counts.next().unwrap_or(&0);
            if next + jokers >= 2 {
                return Value::FullHouse;
            }

            return Value::Three;
        }

        if first + jokers >= 2 {
            jokers -= 2 - first;

            let next = *counts.next().unwrap_or(&0);
            if next + jokers >= 2 {
                return Value::TwoPair;
            }

            return Value::OnePair;
        }

        Value::HighCard
    }
}

#[derive(PartialEq, Eq, PartialOrd, Ord, Debug)]
enum Value {
    HighCard,
    OnePair,
    TwoPair,
    Three,
    FullHouse,
    Four,
    Five,
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        let value = self.value().cmp(&other.value());
        if value == Ordering::Equal {
            self.cards.cmp(&other.cards)
        } else {
            value
        }
    }
}

fn main() {

    let input = aoc::read_input();
    let (_, mut result) = parser::input(&input).expect("Parse error");

    result.sort_by(|a,b| a.0.cmp(&b.0));

    for (rank, (hand, _)) in result.iter().enumerate() {
        println!("{}: {:?} {:?}", rank + 1, hand, hand.value());
    }

    let part1 = result.iter()
        .enumerate()
        .map(|(rank, (_, value))| (rank + 1) * value)
        .fold(0, |a, b| a + b);

    println!("Part 1: {part1}");

}
