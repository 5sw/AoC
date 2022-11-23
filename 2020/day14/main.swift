import Foundation
let input = loadData(day: 14)

class Problem {
    let scanner: Scanner

    /// Each bit where the mask is "1" is set here
    var maskBits: UInt64 = 0

    /// Each bit where the mask is "X" is set here
    var maskUsed: UInt64 = 0
    var mem: [UInt64:UInt64] = [:]

    var writeMem: (Problem, UInt64, UInt64) -> Void

    init(_ input: String, writeMem: @escaping (Problem, UInt64, UInt64) -> Void) {
        scanner = Scanner(string: input)
        self.writeMem = writeMem
    }

    func run() {
        while !scanner.isAtEnd {
            if scanner.string("mask = "), let mask = scanner.scanCharacters(from: Self.maskSet) {
                readMask(mask)
            } else if scanner.string("mem["), let addr = scanner.scanUInt64(), scanner.string("] = "), let value = scanner.scanUInt64() {
                writeMem(self, addr, value)
            } else {
                assertionFailure("Invalid input")
            }
        }


        print("sum", mem.values.reduce(0, +))
    }

    private func readMask(_ mask: String) {
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

    static private let maskSet = CharacterSet(charactersIn: "01X")
}



let part1 = Problem(input) { problem, addr, value in
    problem.mem[addr] = (value & problem.maskUsed) | problem.maskBits
}
part1.run()



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

let part2 = Problem(input) { problem, addr, value in
    for i in possibleValues(problem.maskUsed) {
        let effective = i | ((addr | problem.maskBits) & ~problem.maskUsed)
        problem.mem[effective] = value
    }
}

part2.run()
