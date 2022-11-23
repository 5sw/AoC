//: [Previous](@previous)

import Foundation

func shell(_ value: Int) -> Int {
    return Int(ceil((sqrt(Double(value)) - 1) / 2))
}

func biggestValue(_ shell: Int) -> Int {
    return (2 * shell + 1) * (2 * shell + 1)
}

let value = 16

let s = shell(value)

let shellStart = biggestValue(s - 1) + 1

let shellPosition = value - shellStart

(Float(shellPosition) / 2 + 1) / 2

//: [Next](@next)
