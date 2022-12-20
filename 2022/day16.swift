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

//var path = Path()
//findPath(from: rooms["AA"]!, path: &path)
//print(path.pressure)


struct State {
    var me: String
    var mePrevious: String? = nil
    var meOpened: Bool = false
    
    var elephant: String
    var elephantPrevious: String? = nil
    var elephantOpened: Bool = false
    
    var timeLeft: Int
    var pressure: Int = 0
    var opened: Set<String> = []
}

enum Move: Hashable {
    case openValve
    case move(String)
}

extension State {
    var meRoom: Room { rooms[me]! }
    var elephantRoom: Room { rooms[elephant]! }
    
    func nextMoves() -> [State] {
        let myMoves = moves(from: me, previous: mePrevious, opened: meOpened)
        var elephantMoves = moves(from: elephant, previous: elephantPrevious, opened: elephantOpened)
        
        if me == elephant && myMoves.contains(.openValve) {
           elephantMoves.remove(.openValve) 
        }
        
        var result: [State] = []
        result.reserveCapacity(myMoves.count * elephantMoves.count)
        for a in myMoves {
            for b in elephantMoves {
                var next = self
                next.move(me: a, elephant: b)
                result.append(next)
            }
        }
        
        return result
    }
    
    mutating func move(me: Move, elephant: Move) {
        timeLeft -= 1
        
        switch me {
        case .openValve:
            opened.insert(self.me)
            meOpened = true
            pressure += timeLeft * meRoom.flowRate
            
        case .move(let to):
            mePrevious = self.me
            meOpened = false
            self.me = to
        }
        
        switch elephant {
        case .openValve:
            opened.insert(self.elephant)
            elephantOpened = true
            pressure += timeLeft * elephantRoom.flowRate
            
        case .move(let to):
            elephantPrevious = self.elephant
            elephantOpened = false
            self.elephant = to
        }
    }
    
    func moves(from: String, previous: String?, opened: Bool) -> Set<Move> {
        let room = rooms[from]!
        var result: Set<Move> = []
        result.reserveCapacity(room.connections.count + 1)
        
        if !self.opened.contains(from), room.flowRate > 0 {
            result.insert(.openValve)
        }
        
        for next in room.connections {
            if !opened && next == previous {
                continue
            }
            
            result.insert(.move(next))
        }
        
        return result
    }
}

let initial = State(me: "AA", elephant: "AA", timeLeft: 26)

let allValves = Set(rooms.values.lazy.filter { $0.flowRate > 0 }.map(\.name))

var best = initial

var queue = [initial]
while !queue.isEmpty {
    let next = queue.removeFirst()
    if next.timeLeft == 0 || next.opened == allValves {
        if next.pressure > best.pressure {
            best = next
        }
        continue
    }
    
    queue.append(contentsOf: next.nextMoves())
}

print("Part 2:", best.pressure)
