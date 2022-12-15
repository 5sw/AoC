import Foundation


let input = try String(contentsOf: URL(fileURLWithPath: "day15.input"))
let scanner = Scanner(string: input)

struct Point {
    var x: Int
    var y: Int
}

struct Sensor {
    var position: Point
    var beacon: Point
    
    var distance: Int {
        abs(position.x - beacon.x) + abs(position.y - beacon.y)
    }
    
    func coveredXRange(at y: Int) -> ClosedRange<Int>? {
        let xDistance = distance - abs(position.y - y)
        guard xDistance > 0 else { return nil }
        return position.x - xDistance ... position.x + xDistance
    }
}

extension Scanner {
    func point() -> Point? {
        guard scanString("x=") != nil, let x = scanInt(), scanString(", y=") != nil, let y = scanInt() else {
            return nil
        }
        return Point(x: x, y: y)
    }
    
    func sensor() -> Sensor? {
        guard scanString("Sensor at") != nil, let sensor = point(), scanString(": closest beacon is at") != nil, let beacon = point() else {
            return nil
        }
        
        return Sensor(position: sensor, beacon: beacon)
    }
}

let testY = 2000000


var sensors: [Sensor] = []

while !scanner.isAtEnd {
    guard let sensor = scanner.sensor() else {
        fatalError()
    }
    sensors.append(sensor)
}



func coveredRanges(at testY: Int) -> [ClosedRange<Int>] {
    var events: [(Int, Bool)] = []
    for sensor in sensors {
        guard let range = sensor.coveredXRange(at: testY) else {
            continue
        }
        events.append((range.lowerBound, true))
        events.append((range.upperBound, false))
    }

    events.sort { $0.0 < $1.0 }

    var mergedRanges: [ClosedRange<Int>] = []
    
    var count = 0
    var currentStart: Int? = nil
    var currentEnd: Int? = nil

    for (value, isStart) in events {
        count += isStart ? 1 : -1
        if isStart && currentStart == nil {
            currentStart = value
        } else if isStart, currentEnd == value {
            currentEnd = nil
        } else if isStart, let start = currentStart, let end = currentEnd {
            currentStart = value
            currentEnd = nil
            mergedRanges.append(start ... end)
        } else if !isStart && count == 0 {
            currentEnd = value
        }
    }

    if let start = currentStart, let end = currentEnd {
        mergedRanges.append(start ... end)
    }

    return mergedRanges    
}


var impossiblePositions = 0
for range in coveredRanges(at: testY) {
    impossiblePositions += range.count
}    
print("Part 1:", impossiblePositions)


let possibleRange = 0...4000000

for y in 0...4000000 {
    let ranges = coveredRanges(at: y)
    
    let end = ranges.lazy.map(\.upperBound).filter { possibleRange.contains($0) }.first
    if let end {
        let x = end + 1
        print("Part 2:", x * 4000000 + y)
        break
    }
}
