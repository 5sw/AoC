import Foundation

let input = loadData(day: 2)

var valids = 0
var valid2 = 0

var scanner = Scanner(string: input)
while !scanner.isAtEnd {
    guard let min = scanner.scanInt(),
          scanner.scanString("-") != nil,
          let max = scanner.scanInt(),
          let character = scanner.scanCharacter(),
          scanner.scanString(":") != nil,
          let password = scanner.scanUpToCharacters(from: .newlines)
    else {
        fatalError("Invalid input");
    }


    let count = password.lazy.filter { $0 == character }.count

    if min <= count && count <= max {
        print("valid", min, max, character, password)
        valids += 1
    }

    let first = password.index(password.startIndex, offsetBy: min - 1, limitedBy: password.endIndex).map { password[$0] }
    let second = password.index(password.startIndex, offsetBy: max - 1, limitedBy: password.endIndex).map { password[$0] }

    if (first == character || second == character) && first != second {
        print("valid 2", password)
        valid2 += 1
    }

}

print("Valid old", valids)
print("Valid new", valid2)
