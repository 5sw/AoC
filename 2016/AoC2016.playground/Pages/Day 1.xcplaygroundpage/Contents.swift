import Foundation

let input = """
L5, R1, R4, L5, L4, R3, R1, L1, R4, R5, L1, L3, R4, L2, L4, R2, L4, L1, R3, R1, R1, L1, R1, L5, R5, R2, L5, R2, R1, L2, L4, L4, R191, R2, R5, R1, L1, L2, R5, L2, L3, R4, L1, L1, R1, R50, L1, R1, R76, R5, R4, R2, L5, L3, L5, R2, R1, L1, R2, L3, R4, R2, L1, L1, R4, L1, L1, R185, R1, L5, L4, L5, L3, R2, R3, R1, L5, R1, L3, L2, L2, R5, L1, L1, L3, R1, R4, L2, L1, L1, L3, L4, R5, L2, R3, R5, R1, L4, R5, L3, R3, R3, R1, R1, R5, R2, L2, R5, L5, L4, R4, R3, R5, R1, L3, R1, L2, L2, R3, R4, L1, R4, L1, R4, R3, L1, L4, L1, L5, L2, R2, L1, R1, L5, L3, R4, L1, R5, L5, L5, L1, L3, R1, R5, L2, L4, L5, L1, L1, L2, R5, R5, L4, R3, L2, L1, L3, L4, L5, L5, L2, R4, R3, L5, R4, R2, R1, L5
"""

enum Direction {
    case north
    case east
    case south
    case west

    func turnLeft() -> Direction {
        switch self {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }

    func turnRight() -> Direction {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }

    func move(units: Int) -> (north: Int, east: Int) {
        switch self {
        case .north: return (units, 0)
        case .east: return (0, units)
        case .south: return (-units, 0)
        case .west: return (0, -units)
        }
    }
}

struct Position: Hashable {
    var heading: Direction = .north
    var north: Int = 0
    var east: Int = 0

    mutating func move(left: Bool, units: Int) -> [Position] {
        heading = left ? heading.turnLeft() : heading.turnRight()
        let (north, east) = heading.move(units: 1)

        var result: [Position] = []
        for _ in 0..<units {
            self.north += north
            self.east += east
            result.append(self)
        }

        return result
    }

    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.north == rhs.north && lhs.east == rhs.east
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(north)
        hasher.combine(east)
    }

    var distance: Int {
        abs(north) + abs(east)
    }
}

let scanner = Scanner(string: input)

extension Scanner {
    func scanDirection() -> Bool {
        if scanString("L") != nil { return true }
        if scanString("R") != nil { return false }
        fatalError("Invalid direction")
    }

    func scanMove() -> (Bool, Int) {
        let direction = scanDirection()
        guard let units = scanInt() else {
            fatalError("Invalid distance")
        }

        guard isAtEnd || scanString(",") != nil else {
            fatalError("Missing ,")
        }

        return (direction, units)
    }
}

var position = Position()
var visited: Set<Position> = [position]
var foundPart2 = false
while !scanner.isAtEnd {
    let (direction, units) = scanner.scanMove()
    let path = position.move(left: direction, units: units)

    for position in path {
        if !foundPart2 && !visited.insert(position).inserted {
            print("Part 2: Visited again: \(position.distance): \(position.north)n, \(position.east)e")
            foundPart2 = true
            break
        }
    }
}

print("Part 1:", position.distance)
