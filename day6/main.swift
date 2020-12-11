import Foundation

var input = loadData(day: 6)

let scanner = Scanner(string: input)
scanner.charactersToBeSkipped = nil

var count = 0
var countB = 0
var currentGroup: [Character:Int] = [:]
var peopleInGroup = 0

repeat {
    guard let answers = scanner.scanUpToString("\n") else { fatalError() }
    peopleInGroup += 1
    _ = scanner.scanString("\n")

    for answer in answers {
        currentGroup[answer, default: 0] += 1
    }

    if scanner.isAtEnd || scanner.scanString("\n") != nil {
        count += currentGroup.count

        countB += currentGroup.lazy.filter { $1 == peopleInGroup }.count

        currentGroup.removeAll(keepingCapacity: true)
        peopleInGroup = 0
    }

} while !scanner.isAtEnd

print("count", count)
print("part 2", countB)
