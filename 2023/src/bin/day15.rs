use std::collections::HashMap;

use aoc::read_input;
use itertools::Itertools;
use linked_hash_map::LinkedHashMap;

fn hash_hash(string: &str) -> usize {
    let mut current = 0;
    for ch in string.bytes() {
        current += ch as usize;
        current *= 17;
        current = current % 256;
    }

    current
}

struct LensBox<'a> {
    content: LinkedHashMap<&'a str, usize>
}

impl <'a> LensBox<'a> {
    fn new() -> LensBox<'a> {
        LensBox { 
            content: LinkedHashMap::new()
        }
    }

    fn remove(&mut self, label: &str) {
        self.content.remove(label);
    }

    fn add(&mut self, label: &'a str, power: usize) {
        *self.content.entry(label).or_insert(power) = power;
    }

    fn focus_power(&self, box_index: usize) -> usize {
        self.content.iter().enumerate().fold(0, |a, (lens_index, (_, focus))| a + (box_index + 1) * (lens_index + 1) * *focus)
    }
}

fn main() {
    let input = read_input();
    let input = input.split(',').collect_vec();
    let result = input.iter().map(|str| hash_hash(str)).fold(0, |a,b| a+ b);
    println!("Part 1: {result}");

    let mut boxes = HashMap::new();
    for instruction in input.iter() {
        let index = instruction.find(|ch| ch == '=' || ch == '-').expect("Invalid instruction");
        let label = &instruction[..index];
        let box_index = hash_hash(label);
        let lens_box = boxes.entry(box_index).or_insert_with(|| LensBox::new());
        if  &instruction[index..=index] == "-" {
            lens_box.remove(label)
        } else {
            let power = instruction[(index + 1)..].parse().expect("Invalid instruction");            
            lens_box.add(label, power)
        }
    }

    let part2 = (0..=256)
        .filter_map(|n| Some(boxes.get(&n)?.focus_power(n)) )
        .fold(0, |a, b| a + b);

    println!("Part 2: {part2}");
}