use nom::{IResult, character::complete::{i64, u64, newline, space1}, combinator::map, error::Error, sequence::terminated, multi::separated_list0};

pub fn number(input: &str) -> Result<usize> {
    map(u64, |x| x as usize)(input)
}

pub fn signed_number(input: &str) -> Result<isize> {
    map(i64, |x| x as isize)(input)
}

pub fn numbers(input: &str) -> Result<Vec<isize>> {
    use nom::Parser;
    terminated(separated_list0(space1, signed_number), newline).parse(input)
}

pub type Result<'a, T> = IResult<&'a str, T>;

pub trait Parser<'a, T>: nom::Parser<&'a str, T, Error<&'a str>> {

    fn result(&mut self, input: &'a str) -> std::result::Result<T, nom::Err<Error<&'a str>>> {
        self.parse(input).map(|(_, result)| result)
    }
}
