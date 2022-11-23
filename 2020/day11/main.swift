import Foundation

let input = loadData(day: 11)

enum Spot: Equatable {
    case empty
    case occupied
    case floor
}
typealias Map = [[Spot]]

var map: Map = []

input.enumerateLines { (line, _) in
    map.append(line.map {
        switch $0 {
        case ".": return .floor
        case "#": return .occupied
        case "L": return .empty
        default: fatalError("Invalid input")
        }
    })
}


let adjacents = [
    (-1, -1),
    (0, -1),
    (1, -1),
    (-1, 0),
    (1, 0),
    (-1, 1),
    (0, 1),
    (1, 1)
]

/*
 func step(map: Map) -> Map {
     var result = map
     let width = map[0].count

     for i in 0..<map.count {
         for j in 0..<width where map[i][j] != .floor {
             let occupieds = adjacents.reduce(0) { count, offset in
                 let (x, y) = (offset.0 + j, offset.1 + i)
                 guard 0..<map.count ~= y, 0..<width ~= x else { return count }
                 return count + (map[y][x] == .occupied ? 1 : 0)
             }
             switch (map[i][j], occupieds) {
             case (.empty, 0): result[i][j] = .occupied
             case (.occupied, let n) where n >= 4: result[i][j] = .empty
             default: break
             }
         }
     }

     return result
 }

 */

func occupiedInDirection(at pos: (Int, Int), map: Map, direction: (Int, Int)) -> Int {
    var pos = pos

    let yRange = 0..<map.count
    let xRange = 0..<map[0].count

    while true {
        var (i, j) = pos
        i+=direction.1
        j += direction.0
        pos = (i, j)

        guard yRange ~=  pos.0, xRange ~= pos.1 else { break }
        
        let state = map[i][j]
        switch state {
        case .floor: break
        case .occupied: return 1
        case .empty: return 0
        }
    }
    return 0
}

func step(map: Map) -> Map {
    var result = map
    let width = map[0].count

    for i in 0..<map.count {
        for j in 0..<width where map[i][j] != .floor {
            let occupieds = adjacents.reduce(0) { count, offset in
                count + occupiedInDirection(at: (i, j), map: map, direction: offset)
            }
            switch (map[i][j], occupieds) {
            case (.empty, 0): result[i][j] = .occupied
            case (.occupied, let n) where n >= 5: result[i][j] = .empty
            default: break
            }
        }
    }

    return result
}


while true {
    let next = step(map: map)
    if next == map {
        break
    }
    map = next
}

let totalOccupieds = map.lazy.flatMap { $0 }.filter { $0 == .occupied }.count
print(totalOccupieds)
