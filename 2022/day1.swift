import Foundation

let input = try String(contentsOf: URL(fileURLWithPath: "day1.input"))

let scanner = Scanner(string: input)
scanner.charactersToBeSkipped = nil

var currentElf = 0
var allElves: [Int] = []

while !scanner.isAtEnd {
    if scanner.scanString("\n") != nil {
        allElves.append(currentElf)
        currentElf = 0
    }
    
    if let calories = scanner.scanInt() {
        currentElf += calories
        _ = scanner.scanString("\n")
    }
}
allElves.append(currentElf)

allElves.sort()

print("Maximum:", allElves.last!)
print("Top 3:", allElves.suffix(3).reduce(0, +))