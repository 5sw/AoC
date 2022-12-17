import Foundation
import RegexBuilder

struct Room {
    var name: String
    var flowRate: Int
    var connections: [String]
}


let regex = #/Valve (?<room>[A-Z]{2}) has flow rate=(?<flow>\d+); tunnels? leads? to valves? (?<links>[A-Z]{2}(, [A-Z]{2})*)/#

var rooms: [String: Room] = [:]

for try await line in URL(fileURLWithPath: "day16.input").lines {
    guard let match = try regex.wholeMatch(in: line) else {
        fatalError("Invalid input: \(line)")
    }
    
    rooms[String(match.room)] = Room(name: String(match.room), flowRate: Int(match.flow)!, connections: match.links.split(separator: ", ").map(String.init))
}


struct Path {
    var rooms: [String] = []
    var opened: Set<String> = []
    var pressure: Int = 0
}

let totalTime = 30

func findPath(from room: Room, previous: String? = nil, time: Int = totalTime, path: inout Path) {
    guard time > 0 else { return }
    
    let best = findBest(path: path, room: room, previous: previous, turnedOn: false, time: time - 1)

    if time >= 2, room.flowRate > 0 && path.opened.insert(room.name).inserted {
        path.pressure += (time - 1) * room.flowRate
        path = findBest(path: path, room: room, previous: previous, turnedOn: true, time: time - 2)
    }

    if best.pressure > path.pressure {
        path = best
    }
}

func findBest(path: Path, room: Room, previous: String? = nil, turnedOn: Bool, time: Int) -> Path {
    var path = path
    path.rooms.append("\(room.name)[\(room.flowRate)]\(turnedOn ? "*" : "")")
    
    var best = path
    
    for next in room.connections {
        if !turnedOn && previous == next {
            continue
        }
        
        let nextRoom = rooms[next]!
        
        var nextPath = path
        findPath(from: nextRoom, previous: room.name, time: time, path: &nextPath)
        if nextPath.pressure > best.pressure {
            best = nextPath
        }
    }
    
    return best
}

var path = Path()
findPath(from: rooms["AA"]!, path: &path)
print(path.rooms)
print(path.pressure)