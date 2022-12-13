import Foundation

enum Packet {
    case list([Packet])
    case number(Int)

    init(_ packets: Packet...) {
        self =  .list(packets)
    }
}

extension Scanner {
    func packet() -> Packet? {
        if let list = list() {
            return list
        }
        
        if let int = scanInt() {
            return .number(int)
        }
        
        return nil
    }
    
    func list() -> Packet? {
        guard scanString("[") != nil else {
            return nil
        }
        
        var result: [Packet] = []
        while let packet = packet() {
            result.append(packet)
            _ = scanString(",")
        }
        guard scanString("]") != nil else {
            fatalError("Invalid packet")        
        }
        return .list(result)
    }
}

extension Packet: Comparable {
    static func ==(lhs: Packet, rhs: Packet) -> Bool {
        switch (lhs, rhs) {
            case (.number(let a), .number(let b)): return a == b
            case (.list(let a), .list(let b)): return a == b
            default: return false
        }
    }
    
    static func <(lhs: Packet, rhs: Packet) -> Bool {
        switch (lhs, rhs) {
        case let (.number(a), .number(b)): return a < b
        case (.list, .number): return lhs < .list([rhs])
        case (.number, .list): return .list([lhs]) < rhs
        case let (.list(a), .list(b)): 
            var indexA = a.startIndex
            var indexB = b.startIndex
            while indexA < a.endIndex, indexB < b.endIndex {
                if a[indexA] < b[indexB] {
                    return true
                }
                
                if b[indexB] < a[indexA] {
                    return false
                }
                
                indexA += 1
                indexB += 1
            }
            return indexA == a.endIndex && indexB != b.endIndex
        }
    }
}

let input = try String(contentsOf: URL(fileURLWithPath: "day13.input"))
let scanner = Scanner(string: input)

var index = 1
var sum = 0

let marker1 = Packet(Packet(.number(2)))
let marker2 = Packet(Packet(.number(6)))

var all: [Packet] = [
    marker1, marker2,
]

while !scanner.isAtEnd, let a = scanner.packet(), let b = scanner.packet() {
    all.append(a)
    all.append(b)
    
    if a < b {
        sum += index
    }
    
    index += 1
}

print("Part 1:", sum)

all.sort { $0 < $1 }

let index1 = all.firstIndex(of: marker1)!
let index2 = all.firstIndex(of: marker2)!

print("Part 2:", (index1 + 1) * (index2 + 1))