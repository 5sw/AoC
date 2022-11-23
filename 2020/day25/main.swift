import Foundation

let input = loadData(day: 25).lines().compactMap(Int.init)

func loop(subject: Int, times: Int) -> Int {
    var value = 1
    for _ in 0..<times {
        value = (value * subject) % 20201227
    }
    return value
}

func findLoopSize(subject: Int, expected: Int) -> Int {
    var value = 1
    for i in 0...Int.max {
        if value == expected {
            return i
        }

        value = (value * subject) % 20201227
    }
    return -1
}

let sizes = input.map { findLoopSize(subject: 7, expected: $0) }
print(sizes)

let (pub1, pub2) = (input[0], input[1])
let (loop1, loop2) = (sizes[0], sizes[1])

let secret1 = loop(subject: pub2, times: loop1)
let secret2 = loop(subject: pub1, times: loop2)

print(secret1, secret2)

