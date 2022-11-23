var input: [(from: String, to: String, distance: Int)] = [
    ("Tristram", "AlphaCentauri", 34),
    ("Tristram", "Snowdin", 100),
    ("Tristram", "Tambi", 63),
    ("Tristram", "Faerun", 108),
    ("Tristram", "Norrath", 111),
    ("Tristram", "Straylight", 89),
    ("Tristram", "Arbre", 132),
    ("AlphaCentauri", "Snowdin", 4),
    ("AlphaCentauri", "Tambi", 79),
    ("AlphaCentauri", "Faerun", 44),
    ("AlphaCentauri", "Norrath", 147),
    ("AlphaCentauri", "Straylight", 133),
    ("AlphaCentauri", "Arbre", 74),
    ("Snowdin", "Tambi", 105),
    ("Snowdin", "Faerun", 95),
    ("Snowdin", "Norrath", 48),
    ("Snowdin", "Straylight", 88),
    ("Snowdin", "Arbre", 7),
    ("Tambi", "Faerun", 68),
    ("Tambi", "Norrath", 134),
    ("Tambi", "Straylight", 107),
    ("Tambi", "Arbre", 40),
    ("Faerun", "Norrath", 11),
    ("Faerun", "Straylight", 66),
    ("Faerun", "Arbre", 144),
    ("Norrath", "Straylight", 115),
    ("Norrath", "Arbre", 135),
    ("Straylight", "Arbre", 127),
]

var distances: [String: [String: Int]] = input.reduce(into: [:]) { result, input in
    let (from, to, distance) = input

    result[from, default: [:]][to] = distance
    result[to, default: [:]][from] = distance
}

func totalDistance(route: [String]) -> Int {
    var distance = 0
    var current = route[0]
    for place in route.dropFirst() {
        distance += distances[current]![place]!
        current = place
    }

    return distance
}

func combinations(_ s: Set<String>) -> [[String]] {
    if s.count <= 2 {
        return [Array(s)]
    }

    return s.reduce([]) { result, first in
        let rest = s.subtracting([first])

        return result + combinations(rest).map { sub in
            var result = [first]
            result.append(contentsOf: sub)
            return result
        }
    }
}

combinations(Set(distances.keys))
    .map { totalDistance(route: $0) }
    .max()

