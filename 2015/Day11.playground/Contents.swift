extension String {
    func increment() -> String {
        var ascii = map { $0.asciiValue! }

        var carry: UInt8 = 0
        for index in ascii.indices.reversed() {
            let next = ascii[index] + 1
            if next > UInt8(ascii: "z") {
                carry = 1
                ascii[index] = UInt8(ascii: "a")
            } else {
                ascii[index] = next
                carry = 0
            }

            if carry == 0 {
                break
            }
        }

        if carry != 0 {
            ascii.insert(UInt8(ascii: "a") + carry - 1, at: 0)
        }

        return String(ascii.map { Character(UnicodeScalar($0)) })
    }

    var isValid: Bool {
        containsStraight &&
            !containsForbidden &&
            containsTwoPair
    }

    var containsForbidden: Bool {
        contains { $0 == "i" || $0 == "o" || $0 == "l" }
    }

    var containsStraight: Bool {
        for i in indices.dropLast(2) {
            let next = index(after: i)
            let next2 = index(after: next)

            let value = self.unicodeScalars[i].value
            let value2 = UnicodeScalar(value + 1)
            let value3 = UnicodeScalar(value + 2)

            if self.unicodeScalars[next] == value2 && self.unicodeScalars[next2] == value3 {
                return true
            }
        }
        return false
    }

    var containsTwoPair: Bool {
        var firstPair: Character? = nil
        for i in indices.dropLast() {
            let next = index(after: i)

            guard self[i] == self[next] else { continue }

            if firstPair == nil {
                firstPair = self[i]
            } else if firstPair != self[i] {
                return true
            }

        }
        return false
    }
}


let start = "hxbxwxba"

var password = start
repeat {
    password = password.increment()
} while !password.isValid
password

