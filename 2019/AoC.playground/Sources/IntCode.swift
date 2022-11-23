

func pow(base: Int = 10, _ n: Int) -> Int {
    precondition( n >= 0 )
    switch n {
    case 0: return 1
    case 1: return base
    case _ where n.isMultiple(of: 2):
        return pow(base: base * base, n / 2)
    default:
        return base * pow(base: base * base, n / 2)
    }
}

public protocol IO: class {
    func input() -> Int
    func output(_ value: Int)
}

public class IntCode {
    var memory: [Int]

    var pc = 0
    var base = 0

    var io: IO

    public init(program: [Int], io: IO) {
        self.memory = program
        self.io = io
    }

    func address(_ index: Int) -> Int {
        let mode = (memory[pc] / pow(2 + index - 1)) % 10

        switch mode {
        case 0: return memory[pc + index]
        case 1: return pc + index
        case 2: return memory[pc + index] + base
        default: preconditionFailure("Unknown mode \(mode)")
        }
    }

    func get(_ index: Int) -> Int {
        let addr = address(index)
        return addr < memory.count ? memory[addr] : 0
    }

    func put(_ index: Int, value: Int) {

        let addr = address(index)

        let toAdd = addr - memory.count + 1
        if toAdd > 0 {
            memory.append(contentsOf: Array(repeating: 0, count: toAdd))
        }

        memory[addr] = value
    }


    public func run() {
        loop: while(true) {
            let opcode = memory[pc] % 100

            switch opcode {
            case 1:
                put(3, value: get(1) + get(2))
                pc += 4

            case 2:
                put(3, value: get(1) * get(2))
                pc += 4

            case 3:
                put(1, value: io.input())
                pc += 2

            case 4:
                io.output(get(1))
                pc += 2

            case 5:
                if get(1) != 0 {
                    pc = get(2)
                } else {
                    pc += 3
                }

            case 6:
                if get(1) == 0 {
                    pc = get(2)
                } else {
                    pc += 3
                }

            case 7:
                put(3, value: get(1) < get(2) ? 1 : 0)
                pc += 4

            case 8:
                put(3, value: get(1) == get(2) ? 1 : 0)
                pc += 4

            case 9:
                base += get(1)
                pc += 2

            case 99:
                break loop

            default:
                preconditionFailure("Unknown opcode \(opcode)")

            }
        }
    }
}
