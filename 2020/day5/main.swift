let input = loadData(day: 5).lines()

func decode(_ s: Substring, lower: Character, upper: Character, range: Range<Int>) -> (Int, Substring)
{
    var range = range
    var start = s.startIndex
    while start != s.endIndex && (s[start] == lower || s[start] == upper) {
        let mid = (range.lowerBound + range.upperBound) / 2
        if s[start] == lower {
            range = range.lowerBound..<mid
        } else if s[start] == upper {
            range = mid..<range.upperBound
        }
        start = s.index(after: start)
    }

    return (range.lowerBound, s[start...])
}

func decodeSeat(_ s: String) -> Int {
    let (row, rest) = decode(s[...], lower: "F", upper: "B", range: 0..<128)
    let (column, _) = decode(rest, lower: "L", upper: "R", range: 0..<8)
    let id = row * 8 + column
    print(s, row, column, id)
    return id
}

let foundSeats = Set(input.map { decodeSeat($0) })
print("max seat id", foundSeats.max() ?? -1)

let allSeats = Set(0...(7+127*8))
let freeSeats = allSeats.subtracting(foundSeats)

let yours = freeSeats.first(where: { foundSeats.contains($0 + 1) && foundSeats.contains($0 - 1)})
print("yours", yours ?? -1)
