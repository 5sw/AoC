import Foundation

typealias Item = Int

class Monkey {
    var items: [Item]
    var operation: Operation
    var operand: Operand
    var test: Int
    var trueTarget: Int
    var falseTarget: Int
    var inspectCount = 0
    
    init(items: [Item], operation: Operation, operand: Operand, test: Int, trueTarget: Int, falseTarget: Int) {
        self.items = items
        self.operation = operation
        self.operand = operand
        self.test = test
        self.trueTarget = trueTarget
        self.falseTarget = falseTarget
    }
    
    func run() {
        for item in items {
            inspectCount += 1
            let newLevel = operation.apply(item, operand.value(item: item)) / 3
            let target = newLevel.isMultiple(of: test) ? trueTarget : falseTarget
            monkeys[target].add(newLevel)
        }
        items.removeAll()
    }
    
    func add(_ item: Item) {
        items.append(item)
    }
}

extension Monkey {
    convenience init?(scanner: Scanner) {
        guard scanner.scanString("Monkey") != nil, scanner.scanInt() != nil, scanner.scanString(":") != nil else {
            return nil
        }
        
        guard scanner.scanString("Starting items:") != nil else { return nil }
        let items = scanner.scanList().map(Item.init(_:))
        
        guard scanner.scanString("Operation: new = old") != nil, let operation = scanner.scanOperation(), let operand = scanner.scanOperand() else { return nil }
        
        guard scanner.scanString("Test: divisible by") != nil, let test = scanner.scanInt() else { return nil }
        guard scanner.scanString("If true: throw to monkey") != nil, let trueTarget = scanner.scanInt() else { return nil }
        guard scanner.scanString("If false: throw to monkey") != nil, let falseTarget = scanner.scanInt() else { return nil }
        
        self.init(items: items, operation: operation, operand: operand, test: test, trueTarget: trueTarget, falseTarget: falseTarget)
    }
}


enum Operation: String, CaseIterable {
    case add = "+"
    case multiply = "*"
    
    func apply(_ lhs: Item, _ rhs: Item) -> Item {
        switch self {
            case .add: return lhs + rhs
            case .multiply: return lhs * rhs
        }
    }
}

enum Operand {
    case number(Int)
    case old
    
    func value(item: Item) -> Item {
        switch self {
            case .number(let number): return Item(number)
            case .old: return item
        }
    }
}

extension Scanner {
    func scanList() -> [Int] {
        var result: [Int] = []
        while true {
            guard let int = scanInt() else {
                break
            }
            result.append(int)
            guard scanString(",") != nil else {
                break
            }
        }
        return result
    }
    
    func scanOperation() -> Operation? {
        for op in Operation.allCases {
            if scanString(op.rawValue) != nil {
                return op
            }
        }
        return nil
    }
    
    func scanOperand() -> Operand? {
        if let int = scanInt() {
            return .number(int)
        }
        
        if scanString("old") != nil {
            return .old
        }
        
        return nil
    }
}

let input = try String(contentsOf: URL(fileURLWithPath: "day11.input"))
let scanner = Scanner(string: input)
var monkeys: [Monkey] = []

while !scanner.isAtEnd, let monkey = Monkey(scanner: scanner) {
    monkeys.append(monkey)
}


for _ in 0..<20 {
    for monkey in monkeys {
        monkey.run()
    }
}


let monkeyBusiness = monkeys.map(\.inspectCount).sorted(by: >).prefix(2).reduce(1, *)
print("Part 1:", monkeyBusiness)
