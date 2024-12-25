struct Race {
    time: usize,
    distance: usize,
}

impl Race {
    fn calculate_distance(&self, charge: usize) -> usize {
        let speed = charge;
        let move_time = self.time - charge;
        move_time * speed
    }

    fn ways_to_win(&self) -> usize {
        (1..self.time).filter(|charge| self.calculate_distance(*charge) > self.distance).count()
    }
}

/*
Time:        48     87     69     81
Distance:   255   1288   1117   1623
 */
fn main() {
    let input = vec![
        Race { time: 48, distance:  255 },
        Race { time: 87, distance: 1288 },
        Race { time: 69, distance: 1117 },
        Race { time: 81, distance: 1623 },
    ];

    let part1 = input.iter().map(Race::ways_to_win).fold(1, |a,b| a * b);
    println!("Part 1: {part1}");

    let input2 = Race { time: 48876981, distance: 255128811171623 };
    println!("Part 2: {}", input2.ways_to_win());

}
