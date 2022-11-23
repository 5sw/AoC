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
        guard var result = addition() else { return nil }
        while string("*"), let second = addition() {
            result *= second
        }
        return result
    }

    func addition() -> Int? {
        guard var result = primary() else { return nil }
        while string("+"), let second = primary() {
            result += second
        }
        return result
    }
}

var result = 0
while let e = scanner.expression() {
    result += e
}

print(result)
