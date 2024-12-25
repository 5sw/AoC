use aoc::grid::{Grid, GridVec};
use itertools::Itertools;



fn find_galaxies(grid: &GridVec, empty_columns: &Vec<usize>, empty_rows: &Vec<usize>, expansion_factor: usize) -> Vec<(usize, usize)> {
    let mut offset_y: usize = 0;
    let mut empty_rows = empty_rows.iter();
    let mut next_empty_row = empty_rows.next();
    let mut galaxies: Vec<(usize, usize)> = Vec::new();
    for y in 0..grid.height() {
        if Some(&y) == next_empty_row {
            offset_y += expansion_factor;
            next_empty_row = empty_rows.next();
        }

        let mut offset_x: usize = 0;
        let mut empty_columns = empty_columns.iter();
        let mut next_empty_column = empty_columns.next();
        for x in 0..grid.width() {
            if Some(&x) == next_empty_column {
                offset_x += expansion_factor;
                next_empty_column = empty_columns.next();
            }

            if grid.char_at(x, y) == '#' {
                galaxies.insert(galaxies.len(), (x + offset_x, y + offset_y));
            }
        }
    }

    galaxies
}


fn sum_galaxy_distances(galaxies: &Vec<(usize, usize)>) -> usize {
    let mut sum: usize = 0;
    for i in 0..galaxies.len() {
        for j in 0..i {
            let (ax, ay) = galaxies[i];
            let (bx, by) = galaxies[j];
            
            sum += if ax < bx { bx - ax } else { ax - bx };
            sum += if ay < by { by - ay } else { ay - by };
        }
    }

    sum
}

fn main() {
    let grid = GridVec::read();    

    let empty_columns: Vec<_> = (0..grid.width()).filter(|x| grid.column(*x).all(|ch| ch == '.')).collect();
    let empty_rows: Vec<_> = (0..grid.height()).filter(|y| grid.row(*y).all(|ch| ch == '.')).collect();

    let galaxies = find_galaxies(&grid, &empty_columns, &empty_rows, 1);
    let part1 = sum_galaxy_distances(&galaxies);
    println!("Part 1: {part1}");

    let galaxies = find_galaxies(&grid, &empty_columns, &empty_rows, 1000000 - 1);
    let part2 = sum_galaxy_distances(&galaxies);
    println!("Part 2: {part2}");
}
