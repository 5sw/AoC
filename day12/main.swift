import Foundation
let input = loadData(day: 12)

let scanner = Scanner(string: input)

var position = (north: 0, east: 0)
var waypoint = (north: 1, east: 10)
var direction = 0

/*
 while !scanner.isAtEnd {
     guard let instruction = scanner.scanCharacter(), let value = scanner.scanInt() else {
         fatalError("Invalid input")
     }

     switch instruction {
     case "N": position.north += value
     case "S": position.north -= value
     case "E": position.east += value
     case "W": position.east -= value
     case "L": direction = (360 + direction - value) % 360
     case "R": direction = (direction + value) % 360
     case "F":
         switch direction {
         case 0: position.east += value
         case 90: position.north -= value
         case 180: position.east -= value
         case 270: position.north += value
         default: fatalError("Invalid direction")
         }
     default: fatalError("Invalid command")
     }
 }
 */

func turn(_ degrees: Int) -> (north: Int, east: Int) {
    switch degrees {
    case 0: return waypoint
    case 90: return (-waypoint.east, waypoint.north)
    case 180: return (-waypoint.north, -waypoint.east)
    case 270: return (waypoint.east, -waypoint.north)
    default: fatalError("Invalid direction")
    }
}

while !scanner.isAtEnd {
    guard let instruction = scanner.scanCharacter(), let value = scanner.scanInt() else {
        fatalError("Invalid input")
    }

    switch instruction {
    case "N": waypoint.north += value
    case "S": waypoint.north -= value
    case "E": waypoint.east += value
    case "W": waypoint.east -= value
    case "R": waypoint = turn(value)
    case "L": waypoint = turn(360 - value)
    case "F":
        position.north += value * waypoint.north
        position.east += value * waypoint.east
    default: fatalError("Invalid command")
    }
}

print(abs(position.north) + abs(position.east))
