import Foundation

let input = loadData(day: 8)

let scanner = Scanner(string: input)

enum Instruction: String {
    case nop
    case acc
    case jmp
}

struct Line {
    var instruction: Instruction
    var argument: Int
}

extension Scanner {
    func instruction() -> Instruction? {
        guard let string = scanUpToCharacters(from: .whitespaces),
              let instruction = Instruction(rawValue: string)
        else { return nil }
        return instruction
    }

    func line() -> Line? {
        guard let ins = instruction(),
              let argument = scanInt()
        else { return nil }
        return Line(instruction: ins, argument: argument)
    }

    func program() -> [Line]? {
        var program = [Line]()
        while !isAtEnd {
            guard let line = self.line() else { return nil }
            program.append(line)
        }
        return program
    }
}

class Computer {
    var program: [Line]
    var ip: Int = 0
    var acc: Int = 0

    init(program: [Line]) {
        self.program = program
    }

    var visited: Set<Int> = []

    func runLine() {
        let line = program[ip]
        switch line.instruction {
        case .nop:
            ip += 1

        case .acc:
            acc += line.argument
            ip += 1

        case .jmp:
            ip += line.argument
        }
    }

    func run() {
        ip = 0
        acc = 0

        while ip < program.count {
            let (inserted, _) = visited.insert(ip)
            if !inserted {
                print("Repeated instruction", acc)
                return
            }

            runLine()
        }
        print("Finished", acc)
    }

    func find(ip: Int, acc: Int, changed: Bool, visited: Set<Int>) -> Int?
    {
        if ip >= program.count {
            return acc
        }

        if (visited.contains(ip)) {
            return nil
        }

        let newVisited = visited.union([ip])

        let line = program[ip]
        switch line.instruction {
        case .acc:
            return find(ip: ip + 1, acc: acc + line.argument, changed: changed, visited: newVisited)

        case .nop:
            if let result = find(ip: ip + 1, acc: acc, changed: changed, visited: newVisited) {
                return result
            }

            if !changed, let result = find(ip: ip + line.argument, acc: acc, changed: true, visited: newVisited) {
                print("Found result by changing nop to jmp at", ip)
                return result
            }

        case .jmp:
            if let result = find(ip: ip + line.argument, acc: acc, changed: changed, visited: newVisited) {
                return result
            }

            if !changed, let result = find(ip: ip + 1, acc: acc, changed: true, visited: newVisited) {
                print("Found result by changing jmp to nop at", ip)
                return result
            }
        }

        return nil
    }
}

guard let program = scanner.program() else { fatalError() }
let computer = Computer(program: program)
computer.run()
if let found = computer.find(ip: 0, acc: 0, changed: false, visited: []) {
    print("found solution", found)
}


