import Foundation

let program = [3,8,1001,8,10,8,105,1,0,0,21,38,59,84,93,110,191,272,353,434,99999,3,9,101,5,9,9,1002,9,5,9,101,5,9,9,4,9,99,3,9,1001,9,3,9,1002,9,2,9,101,4,9,9,1002,9,4,9,4,9,99,3,9,102,5,9,9,1001,9,4,9,1002,9,2,9,1001,9,5,9,102,4,9,9,4,9,99,3,9,1002,9,2,9,4,9,99,3,9,1002,9,5,9,101,4,9,9,102,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99]


class Io: IO {
    var inputs = [4, 0, 3, 2, 1, 0]

    func input() -> Int {
        let input = inputs.remove(at: 0)
        return input
    }

    var lastOutput = 0
    func output(_ value: Int) {
        lastOutput = value
        if !inputs.isEmpty {
            inputs.insert(value, at: 1)
        }
    }
}

class Buffered: IO {
    var inputs: [Int] = []
    let condition = NSCondition()
    var outputHandler: (Int) -> Void = { _ in }



    func input() -> Int {
        condition.lock()
        defer { condition.unlock() }

        while inputs.isEmpty {
            condition.wait()
        }

        return inputs.removeFirst()
    }

    func add(input: Int) {
        condition.lock()
        defer { condition.unlock() }

        inputs.append(input)
        condition.signal()
    }

    func output(_ value: Int) {
        outputHandler(value)
    }
}

func test(phases: [Int]) -> Int {

    let ios = phases.map { phase -> Buffered in
        let b = Buffered()
        b.add(input: phase)
        return b
    }

    ios[0].add(input: 0)

    for i in 0 ..< ios.count - 1 {
        ios[i].outputHandler = { [unowned next = ios[i + 1]] val in
            next.add(input: val)
        }
    }

    var lastOutput = -1

    ios[ios.count - 1].outputHandler = { [unowned first = ios[0]] val in
        first.add(input: val)
        lastOutput = val
        print("out>", val)
    }

    let group = DispatchGroup()

    for io in ios {
        DispatchQueue.global().async(group: group) {
            IntCode(program: program, io: io).run()
        }
    }

    group.wait()

    print("done>", lastOutput)
    print("\n\n")

    return lastOutput
}

var maxOutput = Int.min
var maxPhases: [Int] = []

for a in 0...4 {
    for b in 0...4  where b != a {
        for c in 0...4 where c != b && c != a {
            for d in 0...4 where d != c && d != b && d != a {
                for e in 0...4 where e != d && e != c && e != c && e != b && e != a {
                    let phases = [5 + a, 5 + b, 5 + c, 5 + d, 5 + e]
                    let output = test(phases: phases)
                    if maxOutput < output {
                        maxOutput = output
                        maxPhases = phases
                    }
                }
            }
        }
    }
}

maxOutput
maxPhases
