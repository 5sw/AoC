import Foundation

@main
struct Day24: Puzzle {

    func run() {
        let program = readInput()

        var alus: [(Alu, min: Int, max: Int)] = [(Alu(), 0, 0)]

        for instruction in program {
            if case .inp(let register) = instruction {
                buildNextAlus(&alus, register: register)
            } else {
                for index in alus.indices {
                    alus[index].0.run(instruction)
                }
            }
        }

        let serialNumbers = alus
            .lazy
            .filter { $0.0[Alu.resultRegister] == 0 }

        print("Part 1:", serialNumbers.map(\.max).max()!)
        print("Part 2:", serialNumbers.map(\.min).min()!)
    }

    func buildNextAlus(_ alus: inout [(Alu, min: Int, max: Int)], register: RegisterId) {
        var table: [Alu: Int] = [:]

        var newAlus: [(Alu, Int, Int)] = []

        for digit: Alu.Register in 1...9 {
            for (alu, oldMin, oldMax) in alus {
                var alu = alu
                alu[register] = digit
                let newMin = oldMin * 10 + Int(digit)
                let newMax = oldMax * 10 + Int(digit)

                if let index = table[alu] {
                    newAlus[index].1 = min(newAlus[index].1, newMin)
                    newAlus[index].2 = max(newAlus[index].2, newMax)
                } else {
                    table[alu] = newAlus.count
                    newAlus.append((alu, newMin, newMax))
                }
            }
        }

        print("Alu count", newAlus.count)
        alus = newAlus
    }

    func readInput() -> [Instruction] {
        let scanner = Scanner(string: input)
        var program: [Instruction] = []
        while !scanner.isAtEnd {
            program.append(scanner.instruction())
        }
        return program
    }

}


struct Alu: Hashable {
    static let resultRegister: RegisterId = 3
    typealias Register = Int
    var w: Register = 0
    var x: Register = 0
    var y: Register = 0
    var z: Register = 0

    func getValue(_ operand: Operand) -> Register {
        switch operand {
        case .register(let registerId):
            return self[registerId]
        case .number(let int):
            return Register(int)
        }
    }

    subscript(register: RegisterId) -> Register {
        _read {
            switch register {
            case 0: yield w
            case 1: yield x
            case 2: yield y
            case 3: yield z
            default: fatalError()
            }
        }

        _modify {
            switch register {
            case 0: yield &w
            case 1: yield &x
            case 2: yield &y
            case 3: yield &z
            default: fatalError()
        }
        }

        }

    mutating func run(_ instruction: Instruction) {
        switch instruction {
        case .inp:
            break

        case .add(let registerId, let operand):
            self[registerId] += getValue(operand)

        case .mul(let registerId, let operand):
            self[registerId] *= getValue(operand)

        case .div(let registerId, let operand):
            self[registerId] /= getValue(operand)

        case .mod(let registerId, let operand):
            self[registerId] %= getValue(operand)

        case .eql(let registerId, let operand):
            self[registerId] = (self[registerId] == getValue(operand)) ? 1 : 0
        }
    }

}

typealias RegisterId = Int

enum Operand {
    case register(RegisterId)
    case number(Int)
}

enum Instruction {
    case inp(RegisterId)
    case add(RegisterId, Operand)
    case mul(RegisterId, Operand)
    case div(RegisterId, Operand)
    case mod(RegisterId, Operand)
    case eql(RegisterId, Operand)
}

extension Scanner {
    func register() -> RegisterId? {

        if scanString("w") != nil {
            return 0
        }

        if scanString("x") != nil {
            return 1
        }

        if scanString("y") != nil {
            return 2
        }

        if scanString("z") != nil {
            return 3
        }

        return nil
    }

    func operand() -> Operand {
        if let register = register() {
            return .register(register)
        }

        if let int = scanInt() {
            return .number(int)
        }

        fatalError()
    }

    func instruction() -> Instruction {
        guard let command = scanUpToCharacters(from: .whitespaces),
              let target = register()
        else {
                  fatalError()
              }

        switch command {
        case "inp": return .inp(target)
        case "add": return .add(target, operand())
        case "mul": return .mul(target, operand())
        case "div": return .div(target, operand())
        case "mod": return .mod(target, operand())
        case "eql": return .eql(target, operand())
        default: fatalError()
        }
    }
}

let input = """
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 8
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 15
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 11
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 13
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 11
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -3
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 5
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 10
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 11
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -6
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -6
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 14
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -2
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 11
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -9
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
"""
