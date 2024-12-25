use std::{io::stdin, cmp::min};

use aoc::grid::{Grid, GridVec};

fn main() {
    let mut input = stdin().lines().map(|x| x.expect("Cannot read line"));
    let mut sum: usize = 0;

    while let Some(grid) = GridVec::read_one(&mut input) {

        'outer: for i in 1..grid.width() {
            let left = i;
            let right = grid.width() - i;
            let compare = min(left, right);

            for k in 1..=compare {
                if !grid.column(i - k).zip(grid.column(i + k - 1)).all(|(a,b)| a == b) {
                    continue 'outer;
                }
            }

            sum += i;
        }

        'outer: for i in 1..grid.height() {
            let top = i;
            let bottom = grid.height() - i;
            let compare = min(top, bottom);

            for k in 1..=compare {
                if !grid.row(i - k).zip(grid.row(i + k - 1)).all(|(a,b)| a == b) {
                    continue 'outer;
                }
            }

            sum += 100 * i;
        }
    }

    println!("Part 1: {sum}");
}
