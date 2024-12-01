import Foundation
import RegexBuilder

struct Room {
    var name: String
    var flowRate: Int
    var connections: [String]
    var index: Int = -1
}


let regex = #/Valve (?<room>[A-Z]{2}) has flow rate=(?<flow>\d+); tunnels? leads? to valves? (?<links>[A-Z]{2}(, [A-Z]{2})*)/#

var rooms: [String:Room] = [:]

for try await line in URL(fileURLWithPath: "day16.input").lines {
    guard let match = try regex.wholeMatch(in: line) else {
        fatalError("Invalid input: \(line)")
    }
    
    rooms[String(match.room)] = (Room(name: String(match.room), flowRate: Int(match.flow)!, connections: match.links.split(separator: ", ").map(String.init)))
}


let roomsWithValves: [String] = ["AA"] + rooms.values.lazy.filter { $0.flowRate > 0 }.map(\.name).sorted()
for (index, name) in roomsWithValves.enumerated() {
    rooms[name]?.index = index
}

struct Matrix<Element> {
    var size: Int
    var data: [Element]
    
    init(size: Int, data: [Element]) {
        precondition(data.count == size * size)
        self.size = size
        self.data = data
    }
    
    init(size: Int, repeating: Element) {
        self.init(size: size, data: Array(repeating: repeating, count: size * size))
    }
    
    subscript(x: Int, y: Int) -> Element {
        get {
            precondition(0 <= x && x < size && 0 <= y && y < size)
            return data[x + size * y]
        }
        set {
            precondition(0 <= x && x < size && 0 <= y && y < size)
            data[x + size * y] = newValue
        }
    }
    
    mutating func setDiagonal(to value: Element) {
        for i in 0..<size {
            self[i, i] = value
        }
    }
}


var distanceMatrix = Matrix(size: roomsWithValves.count, repeating: Int.max)
distanceMatrix.setDiagonal(to: 0)

func findDistances(start: String, current: String, previous: String? = nil, distance: Int = 0) {
    
    let currentRoom = rooms[current]!
    let startRoom = rooms[start]!
    
    let nextStart = currentRoom.flowRate > 0 ? current : start
    if currentRoom.flowRate > 0 {
        distanceMatrix[startRoom.index, currentRoom.index] = min(distanceMatrix[startRoom.index, currentRoom.index], distance)
    }
    
    for next in currentRoom.connections where next != previous {
        findDistances(start: nextStart, current: next, previous: current, distance: distance + 1)
    }
}

findDistances(start: "AA", current: "AA")

print("   ", terminator: "")
for name in roomsWithValves {
    print("| \(name)  ", terminator: "")
}
print("|")
for y in 0..<distanceMatrix.size {
    print(roomsWithValves[y], "", terminator: "")
    for x in 0..<distanceMatrix.size {
        let value = distanceMatrix[x, y]
        if value == .max {
            print("|     ", terminator: "")
        } else {
            print(String(format: "| %2d  ", value), terminator: "")        
        }
    }
    print("|")
}

