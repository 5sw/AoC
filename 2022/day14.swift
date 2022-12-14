import Foundation
import Darwin


struct Point: Hashable {
    var x: Int
    var y: Int
}

extension Scanner {
    func point() -> Point? {
        guard let x = scanInt(), scanString(",") != nil, let y = scanInt() else {
            return nil
        }
        
        return Point(x: x, y: y)
    }
    
    func line() -> [Point] {
        var result: [Point] = []
        while let point = point() {
            result.append(point)
            guard scanString("->") != nil else {
                break
            }
        }
        return result
    }
}

let input = try String(contentsOf: URL(fileURLWithPath: "day14.input"))
let scanner = Scanner(string: input)

var map: Set<Point> = []

func range(_ a: Int, _ b: Int) -> ClosedRange<Int> {
    min(a, b)...max(a, b)
}

var maxY = 0
var minY = Int.max
var maxX = 0
var minX = Int.max

while !scanner.isAtEnd {
    let line = scanner.line()
    var current = line[0]
    for point in line.dropFirst() {
        if current.x == point.x {
            for y in range(current.y, point.y) {
                map.insert(Point(x: current.x, y: y))
                if y > maxY {
                    maxY = y
                }
                if y < minY {
                    minY = y
                }
            }
            maxX = max(current.x, maxX)
            minX = min(current.x, minX)
        } else if current.y == point.y {
            for x in range(current.x, point.x) {
                map.insert(Point(x: x, y: current.y))
                if x > maxX {
                    maxX = x
                }
                if x < minX {
                    minX = x
                }
            }            
            maxY = max(current.y, maxY)
            minY = min(current.y, minY)
        } else {
            fatalError("Not horizontal/vertical")
        }
        current = point
    }
}
let walls = map

func blocked(_ point: Point) -> Bool {
    if map.contains(point) {
        return true
    }
    
    return point.y >= maxY + 2
}

extension Point {
    func down() -> Point? {
        var copy = self
        copy.y += 1
        if !blocked(copy) {
            return copy
        }
        
        copy.x -= 1
        if !blocked(copy) {
            return copy
        }
        
        copy.x = x + 1
        if !blocked(copy) {
            return copy
        }

        return nil
    }
}

let inlet = Point(x: 500, y: 0)
var part1: Int? = nil

func simulate() {
    var position = inlet
    
    while let next = position.down() {
        position = next
        if position.y >= maxY, part1 == nil {
            part1 = count
        }
    }
    
    map.insert(position)
}


var count = 0
while !map.contains(inlet) {
    simulate()
    count += 1
    show()
    usleep(3000)
}

print("Part 2:", count)

func show() {
    var line = "\u{1b}[2J\u{1b}[H"
    for y in 0...(maxY + 2) {
        for x in (minX-30)...(maxX+30) {
            let point = Point(x:x, y:y)
            let isWall = walls.contains(point) || y >= maxY + 2
            let sand = map.contains(point)
            line += isWall ? "#" : sand ? "o" : " "
        }
        line += "\n"
    }
    line += "\n"
    if let part1 {
        line += "Part 1: \(part1)\n"
    }
    var data = Array(line.utf8)
    write(STDOUT_FILENO, &data, data.count)
}
