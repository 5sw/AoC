use aoc::grid::{GridVec, Grid};

fn main() {
    let mut grid = GridVec::read();
    for y in 0..grid.height() {
        for x in 0..grid.width() {
            if grid.char_at(x, y) != 'O' {
                continue;
            }

            if let Some(open_y) = find_open_spot(&grid, x, y) {
                grid.set_char_at(x, open_y, 'O');
                grid.set_char_at(x, y, '.');
            }
        }
    }

    grid.print();

    let mut sum = 0;
    for y in 0..grid.height() {
        let rocks = grid.line_at(y).chars().filter(|ch| *ch == 'O').count();
        let weight = grid.height() - y;
        sum += weight * rocks;
    }

    println!("Part 1: {sum}");
}

fn find_open_spot(grid: &GridVec, x: usize, y: usize) -> Option<usize> {
    if y == 0 {
        return None;
    }

    let mut new_y = y;
    while new_y > 0 && grid.char_at(x, new_y - 1) == '.' {
        new_y -= 1;
    }

    if new_y != y {
        Some(new_y)
    } else {
        None
    }
}