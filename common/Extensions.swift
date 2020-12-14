import Foundation

extension Scanner {
    @discardableResult
    func string(_ string: String) -> Bool {
        return scanString(string) != nil
    }

    func integers() -> [Int]? {
        var numbers: [Int] = []
        while !isAtEnd {
            guard let num = scanInt() else { return nil }
            numbers.append(num)
        }
        return numbers
    }
}


extension String {
    func lines() -> [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

extension Sequence {
    func print(_ prefix: String = "") -> Self {
        Swift.print(prefix, Array(self))
        return self
    }
}
