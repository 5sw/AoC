import Foundation

let input = [16,1,0,18,12,14,19]

var memory: [Int: (Int, Int?)] = [:]
var last = -1

for (round, num) in input.enumerated() {
    memory[num] = (round, nil)
    last = num
}

func lastRound(for num: Int) -> Int? {
    guard let (first, second) = memory[num] else { return nil }
    if let second = second { return second }
    return first
}

for round in input.count..<30000000 {
    let (first, second) = memory[last]!

    if let second = second {
        last = second - first
    } else {
        last = 0
    }

    if let prev = lastRound(for: last) {
        memory[last] = (prev, round)
    } else {
        memory[last] = (round, nil)
    }
}

print(last)

