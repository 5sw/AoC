use std::{io, cmp::min};

use regex::Regex;

#[derive(Debug)]
struct Grid {
    lines: Vec<String>,
    width: usize
}

impl Grid {
    fn read() -> Grid {
        let lines: Vec<String> = io::stdin().lines().map(|line| line.expect("Cannot read line")).collect();
        let width = lines.first().map_or(0, |l| l.len());
        let ok = lines.iter().skip(1).all(|line| line.len() == width);
        if !ok {
            panic!("Not all lines same length");
        }

        Grid { lines, width }
    }

    fn char_at(&self, x: usize, y: usize) -> char {
        self.lines[y].chars().nth(x).expect("Invalid index")
    }

    fn height(&self) -> usize { self.lines.len() }

    fn numbers<'a>(&'a self, line: usize) -> Vec<(usize, usize, usize)>  {
        let regex: Regex = Regex::new("\\d+").unwrap();

        regex.find_iter(&self.lines[line])
            .map(|x| { 
                let index = x.start();
                let str = x.as_str();
                let result = (index, index + str.len() - 1, str.parse::<usize>().expect("Must be numeric"));
                result
            })
            .filter(move |(start, end, _)| self.has_adjacent_symbol(line, *start, *end))
            .collect::<Vec<(usize, usize, usize)>>()
    }

    fn all_numbers<'a>(&'a self)-> impl Iterator<Item = usize> + 'a {
        (0..self.height())
            .flat_map(|l| self.numbers(l))
            .map(|(_, _, num)| num)
        
    }

    fn has_adjacent_symbol(&self, line: usize, start: usize, end: usize) -> bool {
        if start > 0 && is_symbol(self.char_at(start - 1, line)) {
            return true;
        }

        if end + 1 < self.width && is_symbol(self.char_at(end + 1, line)) {
            return true;
        }

        let xmin = if start > 0 { start - 1 } else { start };
        let xmax = min(end + 1, self.width - 1);
        if line > 0 && self.lines[line - 1][xmin..=xmax].contains(is_symbol) {
            return true;
        }

        if line + 1 < self.height() && self.lines[line + 1][xmin..=xmax].contains(is_symbol) {
            return true;
        }

        false
    }
}

fn is_symbol(ch: char) -> bool {
    ch != '.' && !ch.is_numeric()
}

fn main() {
    let grid = Grid::read();
    let part1 = grid.all_numbers().fold(0, |a, b| a + b);
    println!("Part 1: {part1}");
}