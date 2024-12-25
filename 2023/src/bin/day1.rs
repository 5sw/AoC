use std::io;
use std::collections::HashMap;
use std::str::FromStr;
use regex::Regex;

fn main()  {
    let mut sum = 0u32;
    let mut sum2: u32 = 0;

    let digit_names: HashMap<&str, u32> = HashMap::from([
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9)
    ]);

    let regex_string = digit_names.keys()
    .fold("\\d".to_owned(), |a,b| a + "|" + b);
        println!("Regex: {regex_string}");
        let regex = Regex::from_str(&regex_string).expect("Invalid regex");

    let get_digit = |m: regex::Match<'_>| {
        let digit = m.as_str();
        digit.parse::<u32>()
            .map_or(None, |x| Some(x))
            .or(digit_names.get(digit).copied())
            .expect("Regex doesn’t work")
    };

    for line in  io::stdin().lines() {
        let line = line.unwrap();
        let line = line.trim();

        let digits: Vec<_> = line.chars()
        .flat_map(|digit| digit.to_digit(10))
        .collect();

        if let (Some(first), Some(last)) = (digits.first(), digits.last()) {
            sum += first * 10 + last
        }

        let match1 = regex.find(line)
            .map(get_digit);
        let match2 = (0..line.len()).rev().filter_map(|pos| regex.find_at(line, pos)).next()
            .map(get_digit);

        if let (Some(first), Some(last)) = (match1, match2) {
            sum2 += first * 10 + last
        }

    } 

    println!("Part 1: {sum}");
    println!("Part 2: {sum2}");
}
