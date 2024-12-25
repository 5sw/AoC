use std::{collections::{HashMap, HashSet}, cmp::max};

use aoc::grid::{GridVec, Grid};
use array2d::Array2D;

fn grid_position(grid: &GridVec, x: isize, y: isize) -> Option<(usize, usize)> {
    if x < 0 || y < 0 {
        return None;
    }

    let cur_x: usize = x.try_into().unwrap();
    let cur_y: usize = y.try_into().unwrap();

    if cur_x >= grid.width() || cur_y >= grid.height() {
        return None;
    }

    return Some((cur_x, cur_y));
}

fn trace(grid: &GridVec, energized: &mut Array2D<bool>, cache: &mut HashMap<(isize, isize, isize, isize), ()>, mut x: isize, mut y: isize, mut dx: isize, mut dy: isize) {

    let key = (x, y, dx, dy);
    if let Some(cached) = cache.get(&key) {
        println!("Cached result found for {:?}", key);
        return *cached;
    }
    
    cache.insert(key, ());

    let mut steps = HashSet::new();

    while let Some((cur_x, cur_y)) = grid_position(grid, x, y) {
        energized[(cur_y, cur_x)] = true;
        let cur_ch = grid.char_at(cur_x, cur_y);
        // println!("{x},{y} ({dx},{dy}) {cur_ch} ");

        match cur_ch {
            '/' => (dx, dy) = (-dy, -dx),
            '\\' =>  (dx, dy) = (dy, dx),
            '|' if dy == 0 => {
                trace(grid, energized, cache, x, y - 1, 0, -1);
                (dx, dy) = (0, 1);
            }
            '-' if dx == 0 => {
                trace(grid, energized, cache, x - 1, y, -1, 0);
                (dx, dy) = (1, 0);
            },
            '-' | '|' | '.' => {},
            _ => panic!("Unknown character")
        };

        assert!(dx == 0 || dy == 0);

        x += dx;
        y += dy;

        if !steps.insert((x, y, dx, dy)) {
            println!("Loop detected, stopping");
            break;
        }
    }

}

fn energized(grid: &GridVec, x: isize, y: isize, dx: isize, dy: isize) -> usize {
    let mut energized = Array2D::filled_with(false, grid.height(), grid.width());
    let mut cache = HashMap::new();
    trace(&grid, &mut energized, &mut cache, x, y, dx, dy);
    energized.elements_row_major_iter().filter(|energized| **energized).count()
}

fn main() {
    let grid = GridVec::read();
    let part1 = energized(&grid, 0, 0, 1, 0);
    println!("Part 1: {part1}");

    let mut part2 = 0;

    let x_max: isize = grid.width().try_into().unwrap();
    let y_max: isize = grid.height().try_into().unwrap();

    for y in 0..y_max {
        let a = energized(&grid, 0, y, 1, 0);
        let b = energized(&grid, x_max - 1, y, -1, 0);
        part2 = max(part2, max(a, b));
    }

    for x in 0..x_max {
        let a = energized(&grid, x, 0, 0, 1);
        let b = energized(&grid, x, y_max - 1, 0, -1);
        part2 = max(part2, max(a, b));
    }

    println!("Part 2: {part2}");
}
