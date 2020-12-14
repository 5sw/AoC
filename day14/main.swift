import Foundation
let scanner = Scanner(string: loadData(day: 14))


var maskBits: UInt64 = 0
var maskUsed: UInt64 = 0


var mem: [UInt64:UInt64] = [:]


func readMask(_ mask: String) {
    assert(mask.count == 36)

    maskBits = 0
    maskUsed = 0

    for char in mask {
        maskBits <<= 1
        maskUsed <<= 1

        switch char {
        case "1": maskBits |= 1
        case "0": break
        case "X": maskUsed |= 1
        default: assertionFailure("Invalid character in mask")
        }
    }
}

func applyMask(_ value: UInt64) -> UInt64 {
    (value & maskUsed) | maskBits
}

let maskSet = CharacterSet(charactersIn: "01X")

/*
while !scanner.isAtEnd {
    if scanner.string("mask = "), let mask = scanner.scanCharacters(from: maskSet) {
        readMask(mask)
    } else if scanner.string("mem["), let addr = scanner.scanInt(), scanner.string("] = "), let value = scanner.scanUInt64() {
        mem[addr] = applyMask(value)
    } else {
        assertionFailure("Invalid input")
    }
}
 */


func printPadded(_ val: UInt64) {
    let s = String(val, radix: 2)
    print(String(repeating: " ", count: 36 - s.count) + s)
}

func possibleValues(_ mask: UInt64) -> [UInt64] {
    var values: [UInt64] = []
    var mask = mask
    for i in 0..<36 {
        if mask & 1 != 0 {
            let bit: UInt64 = 1 << i
            if values.isEmpty {
                values.append(0)
                values.append(bit)
            } else {
                values.append(contentsOf: values.map { $0 | bit })
            }
        }
        mask >>= 1
    }

    return values
}

func writeMem(_ addr: UInt64, _ value: UInt64) {
    for i in possibleValues(maskUsed) {
        let effective = i | ((addr | maskBits) & ~maskUsed)
        mem[effective] = value
    }
}

while !scanner.isAtEnd {
    if scanner.string("mask = "), let mask = scanner.scanCharacters(from: maskSet) {
        readMask(mask)
    } else if scanner.string("mem["), let addr = scanner.scanUInt64(), scanner.string("] = "), let value = scanner.scanUInt64() {
        writeMem(addr, value)
    } else {
        assertionFailure("Invalid input")
    }
}


print("sum", mem.values.reduce(0, +))
