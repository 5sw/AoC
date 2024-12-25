use aoc::read_input;

#[derive(Debug)]
struct MapEntry {
    destination: usize,
    source: usize,
    length: usize,
}

impl MapEntry {
    fn map(&self, input: usize) -> Option<usize> {
        if input < self.source || self.source + self.length <= input {
            return None
        }

        return Some(self.destination + ( input - self.source))
    }
}

#[derive(Debug)]
struct Map {
    entries: Vec<MapEntry>
}

impl Map {
    fn map(&self, input: usize) -> usize {
        self.entries.iter()
            .find_map( |e| e.map(input))
            .unwrap_or(input)
    }
}

mod parser {
    use aoc::parsing::number;
    use nom::{IResult, sequence::{tuple, preceded, terminated}, character::complete::{newline, multispace1}, multi::{separated_list0, count}, error::Error, bytes::complete::tag};
    use nom::Parser;

    use crate::MapEntry;

     fn map_entry(input: &str) -> IResult<&str, MapEntry> {
        tuple((
            number,
            preceded(multispace1, number),
            preceded(multispace1, number),
        ))
        .map(|(a, b, c)| MapEntry{destination: a, source: b, length: c})
        .parse(input)
    }

     fn map(input: &str) -> IResult<&str, crate::Map> {
        terminated(separated_list0(newline, map_entry),newlines)
        .map(|x| crate::Map{entries: x})
        .parse(input)
    }

     fn map_with_title(title: &str) -> impl Parser<&str, crate::Map, Error<&str>>{
        preceded(tuple((tag(title), tag(":"), newline)), map)
    }

    fn newlines(input: &str) -> IResult<&str, ()> {
        count(newline, 2).map(|_| ()).parse(input)
    }

    fn seeds(input: &str) -> IResult<&str, Vec<usize>> {
        terminated(preceded(tag("seeds: "), separated_list0(multispace1, number)), newlines)
        .parse(input)
    }

    pub fn input(input: &str) -> IResult<&str, (Vec<usize>, crate::Map, crate::Map, crate::Map, crate::Map, crate::Map, crate::Map, crate::Map)> {
        tuple((
            seeds,
            map_with_title("seed-to-soil map"),
            map_with_title("soil-to-fertilizer map"),
            map_with_title("fertilizer-to-water map"),
            map_with_title("water-to-light map"),
            map_with_title("light-to-temperature map"),
            map_with_title("temperature-to-humidity map"),
            map_with_title("humidity-to-location map")
        ))
        .parse(input)
    }
}

fn main() {
    let data = read_input();
    let (_, input) = parser::input(&data).expect("Stuff");
    let (seeds, seed_soil, soil_fertilizer, fertilizer_water, water_light, light_temp, temp_humid, humid_location) = input;
    let x = seeds.iter()
        .map(|seed| seed_soil.map(*seed) )
        .map(|soil| soil_fertilizer.map(soil) )
        .map(|fert| fertilizer_water.map(fert) )
        .map(|water| water_light.map(water) )
        .map(|light| light_temp.map(light) )
        .map(|temp| temp_humid.map(temp) )
        .map(|humid| humid_location.map(humid) )
        .min()
        .expect("Need a solution");

    println!("Part 1: {x}");
}