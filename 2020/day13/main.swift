import Foundation

let input = loadData(day: 13)


let scanner = Scanner(string: input)

let startTime = scanner.scanInt()!

var busLines: [(Int, position: Int)] = []

var position = 0
repeat {
    if let line = scanner.scanInt() {
        busLines.append((line, position))
    } else if scanner.string("x") {
        // Ignore
    }
    position += 1
} while scanner.string(",")

let min = busLines
    .map { $0.0 }
    .map { ((startTime / $0) * $0 + $0, $0) }
    .print()
    .min(by: { $0.0 < $1.0 })!


print((min.0 - startTime) * min.1)

let max = busLines.max(by: { $0.0 < $1.0 })!
print(max)

/*
 brute force - takes too long

var s = sequence(first: 0, next: { $0 + max.0 })
    .lazy
    .filter { t in busLines.allSatisfy { (t - max.position + $0.position).isMultiple(of: $0.0 )} }
    .makeIterator()

print(s.next())

*/

var step = 0
var time = 0

outer: while true {
    time += step

    step = 1
    for (bus, position) in busLines {
        guard (time + position).isMultiple(of: bus) else { continue outer }
        step *= bus
    }

    break
}

print("part2", time)
