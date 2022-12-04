use std::fs::File;
use std::io::{self, BufRead};

#[derive(Debug, Copy, Clone)]
struct Range{ min: i32, max: i32 }

impl Range {
    fn from_string(s: &str) -> Option<Range> {
        let mut parts = s.split('-');
        let min: i32 = parts.next().map(|s| s.parse::<i32>().ok()).flatten()?;
        let max: i32 = parts.next().map(|s| s.parse::<i32>().ok()).flatten()?;
        Some(Range{min: min,max: max})
    }
    
    fn contains(self, other: Range) -> bool {
        self.min <= other.min && other.max <= self.max
    }
    
    fn contains_value(self, value: i32) -> bool {
        self.min <= value && value <= self.max
    }
    
    fn overlaps(self, other: Range) -> bool {
        self.contains_value(other.min) || 
            self.contains_value(other.max) ||
            other.contains_value(self.min) ||
            other.contains_value(self.max)
    }
}

fn main() {
    let file = File::open("day4.input")
        .expect("Can open file");

    let mut contained = 0;
    let mut overlapping = 0;
    
    for l in io::BufReader::new(file).lines() {
        let line = l.expect("Cannot read line");
        let mut ranges = line.split(',').map(Range::from_string).flatten();
        
        let first = ranges.next().expect("Invalid input");
        let second = ranges.next().expect("Invalid input");
        
        if first.contains(second) || second.contains(first) {
            contained += 1;
        }
        
        if first.overlaps(second) {
            overlapping += 1
        }
    }
    
    println!("Part 1: Contained pairs   {}", contained);
    println!("Part 2: Overlapping pairs {}", overlapping);
}

