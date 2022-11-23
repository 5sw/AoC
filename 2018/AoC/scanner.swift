import Foundation

extension Scanner {
    func scan(string: String) -> Bool {
        return scanString(string, into: nil)
    }

    func scan() -> Int? {
        var result: Int = 0
        guard scanInt(&result) else { return nil }
        return result
    }
}

