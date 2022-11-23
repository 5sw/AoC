import Foundation

let input = loadData(day: 16)
let scanner = Scanner(string: input)

extension Scanner {
    func scanRange() -> ClosedRange<Int>? {
        guard let low = scanInt(),
              string("-"),
              let high = scanInt()
        else { return nil }
        return low...high
    }

    func scanFieldDefinition() -> (String, ClosedRange<Int>, ClosedRange<Int>)? {
        var location = scanLocation
        guard let name = scanUpToString(":"),
              string(":"),
              let first = scanRange(),
              string("or"),
              let second = scanRange()
        else {
            scanLocation = location
            return nil
        }
        return (name, first, second)
    }

    func scanFieldDefinitions() -> [(String, ClosedRange<Int>, ClosedRange<Int>)] {
        var result = [(String, ClosedRange<Int>, ClosedRange<Int>)]()
        while let field = scanFieldDefinition() {
            result.append(field)
        }

        return result
    }

    func scanTicket() -> [Int]? {
        var result = [Int]()
        repeat {
            guard let field = scanInt() else { return nil }
            result.append(field)
        } while string(",")
        return result
    }

    func scanYourTicket() -> [Int]? {
        guard string("your ticket:"),
              let ticket = scanTicket()
        else { return nil }
        return ticket
    }

    func scanNearbyTickets() -> [[Int]]? {
        guard string("nearby tickets:") else { return nil }
        var result = [[Int]]()
        while !isAtEnd {
            guard let ticket = scanTicket() else { return nil }
            result.append(ticket)
        }
        return result
    }
}

let definitions = scanner.scanFieldDefinitions()
guard let yourTicket = scanner.scanYourTicket(),
      let nearbyTickets = scanner.scanNearbyTickets()
else { fatalError() }


func isValid(_ value: Int) -> Bool {
    definitions.contains {
        $0.1.contains(value) || $0.2.contains(value)
    }
}

func isValid(_ ticket: [Int]) -> Bool {
    ticket.allSatisfy(isValid)
}

let invalidSums = nearbyTickets
    .flatten()
    .filter( { !isValid($0) } )
    .reduce(0, +)

print(invalidSums)


var possibleFields: [Set<String>] = Array(repeating: Set(definitions.map { $0.0 }), count: yourTicket.count)

for ticket in nearbyTickets where isValid(ticket) {
    for (index, value) in ticket.enumerated() {
        for (name, first, second) in definitions {
            if !(first.contains(value) || second.contains(value)) {
                possibleFields[index].remove(name)
            }
        }
    }
}

for index in possibleFields.indices.sorted(by: { possibleFields[$0].count < possibleFields[$1].count }) {
    guard possibleFields[index].count == 1, let key = possibleFields[index].first else { fatalError() }
    for i in possibleFields.indices where i != index {
        possibleFields[i].remove(key)
    }
}

let mapping = possibleFields.map { $0.first! }

let result = mapping.enumerated()
    .map { ($0.element, yourTicket[$0.offset]) }
    .filter { $0.0.hasPrefix("departure") }
    .map { $0.1 }
    .reduce(1, *)

print(result)
