use aoc::grid::{Grid, GridVec};
use std::iter::Iterator;

trait MoreGrid: Grid { 

    fn trace(&self, start: (usize, usize), start_direction: Direction) -> Option<usize> {
        let mut position = start;
        let mut direction = start_direction;
        let mut count: usize = 0;
        while let Some(new_position) = self.next_position(position, direction) {
            count += 1;
            let (x, y) = new_position;
            position = new_position;
            if start == position {
                return Some(count);
            }

            if let Some(dir) = next_direction(direction.opposite(), self.char_at(x, y)) {
                direction = dir;
            } else {
                return None
            }
        }
        None
    }

    fn longest_loop(&self) -> Option<usize> {
        if let Some(start) = self.find('S') {
            vec![Direction::Top, Direction::Right, Direction::Bottom, Direction::Left]
                .iter()
                .filter_map(|dir| self.trace(start, *dir))
                .max()
        } else {
            None
        }
    }

    fn next_position(&self, current: (usize, usize), direction: Direction) -> Option<(usize, usize)> {
        let (x, y) = current;
        match direction {
            Direction::Left => if x > 0 { Some((x - 1, y)) } else { None },
            Direction::Right => if x + 1 < self.width() { Some((x + 1, y))} else { None },
            Direction::Top => if y > 0 { Some((x, y - 1)) } else { None },
            Direction::Bottom => if y + 1 < self.height() { Some((x, y + 1)) } else { None }
        }
    }

}

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Direction {
    Top,
    Left,
    Right,
    Bottom
}

fn connections(ch: char) -> Option<(Direction, Direction)> {
    match  ch {
        '|' => Some((Direction::Top, Direction::Bottom)),
        '-' => Some((Direction::Left, Direction::Right)),
        'L' => Some((Direction::Top, Direction::Right)),
        'J' => Some((Direction::Left, Direction::Top)),
        '7' => Some((Direction::Left, Direction::Bottom)),
        'F' => Some((Direction::Bottom, Direction::Right)),
        '.' => None,
        _ => panic!("Invalid direction")
    }
}

fn next_direction(from: Direction, ch: char) -> Option<Direction> {
    if let Some(pair) = connections(ch) {
        match pair {
            (f, result) if f == from => Some(result),
            (result, f) if f == from => Some(result),
            _ => None
        }
    } else {
        None
    }
}

impl Direction {
    fn opposite(self) -> Direction {
        match self {
            Self::Top => Self::Bottom,
            Self::Bottom => Self::Top,
            Self::Left => Self::Right,
            Self::Right => Self::Left
        }
    }
}

impl <T: Grid> MoreGrid for T {}

fn main() {
    let grid = GridVec::read();    

    println!("Part 1: {}", grid.longest_loop().expect("No solution") / 2);
}
