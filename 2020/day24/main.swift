import Foundation

let input = loadData(day: 24)
let scanner = Scanner(string: input)
scanner.charactersToBeSkipped = nil

enum Direction: String, CaseIterable {
    case east = "e"
    case southEast = "se"
    case southWest = "sw"
    case west = "w"
    case northWest = "nw"
    case northEast = "ne"
}

extension Scanner {
    func readDirection() -> Direction? {
        for dir in Direction.allCases {
            if string(dir.rawValue) {
                return dir
            }
        }
        return nil
    }
}

struct Coord: Hashable {
    var south: Int
    var east: Int

    static let zero = Coord(south: 0, east: 0)

    mutating func move(_ direction: Direction) {
        switch direction {
        case .east:
            east += 1
        case .southEast:
            south += 1

        case  .southWest:
            south += 1
            east -= 1

        case .west:
            east -= 1

        case .northWest:
            south -= 1

        case .northEast:
            south -= 1
            east += 1
        }
    }

    func neighbor(_ direction: Direction) -> Coord {
        var result = self
        result.move(direction)
        return result
    }

    var neighbors: [Coord] {
        Direction.allCases.map(neighbor)
    }
}

func readCoordinate() -> Coord {
    var current = Coord.zero
    while let direction = scanner.readDirection() {
        current.move(direction)
    }
    precondition(scanner.string("\n"))
    return current
}

var floor: [Coord: Bool] = [:]
var northWestCorner = Coord.zero
var southEastCorner = Coord.zero


func expandRange(toInclude coord: Coord) {
    northWestCorner.east = min(northWestCorner.east, coord.east)
    northWestCorner.south = min(northWestCorner.south, coord.south)

    southEastCorner.east = max(southEastCorner.east, coord.east)
    southEastCorner.south = max(southEastCorner.south, coord.south)
}

while !scanner.isAtEnd {
    let coord = readCoordinate()
    expandRange(toInclude: coord)

    floor[coord, default: false].toggle()
}

print("part 1:", floor.values.lazy.filter { $0 }.count)

func step() -> [Coord: Bool] {
    var result = floor

    for east in (northWestCorner.east - 1)...(southEastCorner.east + 1) {
        for south in (northWestCorner.south - 1)...(southEastCorner.south + 1) {
            let coord = Coord(south: south, east: east)

            let isBlack = floor[coord, default: false]

            let blackNeighbors = coord.neighbors
                .lazy
                .map { floor[$0, default: false] }
                .filter { $0 }
                .count

            if isBlack && (blackNeighbors == 0 || blackNeighbors > 2) {
                result[coord] = false
            } else if !isBlack && blackNeighbors == 2 {
                result[coord] = true
                expandRange(toInclude: coord)
            }
        }
    }

    return result
}

for _ in 0..<100 {
    floor = step()
}

print("part 2:", floor.values.lazy.filter { $0 }.count)
