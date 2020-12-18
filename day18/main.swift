import Foundation
let input = loadData(day: 18)
let scanner = Scanner(string: input)

extension Scanner {
    func primary() -> Int? {
        if let num = scanInt() {
            return num
        }

        if string("(") {
            let result = expression()
            if !string(")") {
                fatalError()
            }
            return result
        }

        return nil
    }

    func op() -> String? {
        scanString("+") ?? scanString("*")
    }

    func expression() -> Int? {
        guard var result = primary() else { return nil }
        while let op = self.op() {
            guard let second = primary() else { fatalError() }
            switch op {
            case "+": result += second
            case "*": result *= second
            default: fatalError()
            }
        }
        return result
    }
}

var result = 0
while let e = scanner.expression() {
    result += e
}

print(result)
