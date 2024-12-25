use std::{io, str::Chars, iter::FusedIterator};

use itertools::Itertools;

#[derive(Debug)]
pub struct GridVec {
    lines: Vec<String>,
    width: usize,
}

pub struct Column<'a> {
    grid: &'a GridVec,
    x: usize,
    y: usize
}

impl <'a> Column<'a> {
    fn new(grid: &'a GridVec, x: usize) -> Column<'a> {
        Column { grid, x, y: 0 }
    }
}

impl <'a> Iterator for Column<'a> {
    type Item = char;

    fn next(&mut self) -> Option<Self::Item> {
        if self.y < self.grid.height() {
            let result = self.grid.char_at(self.x, self.y);
            self.y += 1;
            Some(result)
        } else {
            None
        }
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let len = self.len();
        (len, Some(len))
    }
}

impl ExactSizeIterator for Column<'_> {
    fn len(&self) -> usize {
        self.grid.height() - self.y
    }
}

impl  FusedIterator for Column<'_> {}


pub trait Grid where Self: Sized {
    type ColumnIter<'a>: ExactSizeIterator<Item = char> + 'a where Self: 'a;
    type RowIter<'a>: Iterator<Item = char> + 'a where Self: 'a;

    fn new(lines: Vec<String>) -> Self;

     fn read() -> Self {
        let lines: Vec<String> = io::stdin().lines().map(|line| line.expect("Cannot read line")).collect();

        Self::new(lines)
    }

    fn read_one<I>(input: &mut I) -> Option<Self>
        where I: Iterator<Item = String>
    {
        let lines = input.take_while(|l| !l.is_empty()).collect_vec();
        if lines.is_empty() {
            None
        } else {
            Some(Self::new(lines))
        }
    }

     fn char_at(&self, x: usize, y: usize) -> char {
        self.line_at(y).chars().nth(x).expect("Invalid index")
     }

     fn set_char_at(&mut self, x: usize, y:  usize, ch: char);

     fn height(&self) -> usize;
     fn width(&self) -> usize;

     fn line_at(&self, y: usize) -> &str;

     fn find(&self, ch: char) -> Option<(usize, usize)> {
        for y in 0..self.height() {
            if let Some(pos) = self.line_at(y).find(ch) {
                return Some((pos, y));
            }
        }



        None
    }

    fn column<'a>(&'a self, x: usize) -> Self::ColumnIter<'a>;
    fn row<'a>(&'a self, y: usize) -> Self::RowIter<'a>;
}

impl Grid for GridVec {

    type ColumnIter<'a> = Column<'a>;
    type RowIter<'a> =  Chars<'a>;

    fn column<'a>(&'a self, x: usize) -> Self::ColumnIter<'a> {
        Column::new(self, x)
    }

    fn row<'a>(&'a self, y: usize) -> Self::RowIter<'a> {
        self.line_at(y).chars()
    }

    fn new(lines: Vec<String>) -> Self {
        let width = lines.first().map_or(0, |l| l.len());
        let ok = lines.iter().skip(1).all(|line| line.len() == width);
        if !ok {
            println!("Read lines: {:?}", lines);
            panic!("Not all lines same length");
        }

        GridVec {lines, width }
    }

    fn char_at(&self, x: usize, y: usize) -> char {
        self.lines[y].chars().nth(x).expect("Invalid index")
    }

    fn set_char_at(&mut self, x: usize, y:  usize, ch: char) {

        let line = &mut self.lines[y];
        line.replace_range(x..=x, &ch.to_string());
     }

     fn height(&self) -> usize { self.lines.len() }
     fn width(&self) -> usize { self.width }

     fn line_at(&self, y: usize) -> &str {
        &self.lines[y]
     }

}

impl GridVec {
    pub fn print(&self) {
        for line in self.lines.iter() {
            println!("{line}");
        }
    }
}
