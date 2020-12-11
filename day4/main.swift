import Foundation

let input = loadData(day: 4)

let scanner = Scanner(string: input)
scanner.charactersToBeSkipped = nil

extension Scanner {
    func field() -> (String, String)? {
        guard let name = scanUpToString(":"),
              scanString(":") != nil,
              let value = scanUpToCharacters(from: .whitespacesAndNewlines)
        else { return nil }
        return (name, value)
    }

    func passport() -> [String: String]? {
        var fields = [(String, String)]()
        while !isAtEnd && scanString("\n\n") == nil {
            _ = scanner.scanCharacters(from: .whitespacesAndNewlines)
            guard let field = field() else { return nil }
            fields.append(field)
        }
        return try? Dictionary(fields, uniquingKeysWith: { _, _ in throw NSError(domain: "error", code: 1, userInfo: nil) })
    }
}

var valids = 0
var valid2 = 0

let requiredFields = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
]

func validHeight(_ height: String) -> Bool {
    let scanner = Scanner(string: height)
    guard let number = scanner.scanInt() else { return false }
    if scanner.scanString("cm") != nil, 150...193 ~=  number {
        return true
    }

    if scanner.scanString("in") != nil, 59...76 ~= number {
        return true
    }

    return false
}

func validHairColor(_ hcl: String) -> Bool {
    let scanner = Scanner(string: hcl)
    guard scanner.scanString("#") != nil else { return false }
    guard scanner.scanCharacters(from: CharacterSet(charactersIn: "0123456789abcdef"))?.count == 6 else { return false }
    return scanner.isAtEnd
}

let validEyeColors: Set<String> = [
    "amb",
    "blu",
    "brn",
    "gry",
    "grn",
    "hzl",
    "oth"
]

func isValidPassportId(_ pid: String) -> Bool {
    return pid.count == 9 && Int(pid) != nil
}

while !scanner.isAtEnd {
    guard let passport = scanner.passport() else { fatalError() }
    print(passport)

    let valid = requiredFields.allSatisfy { passport.keys.contains($0) }
    if valid {
        valids += 1
    }

    guard let year = passport["byr"].flatMap(Int.init), 1920...2002 ~= year else { continue }
    guard let issueYear = passport["iyr"].flatMap(Int.init), 2010...2020 ~= issueYear else { continue }
    guard let expireYear = passport["eyr"].flatMap(Int.init), 2020...2030 ~= expireYear else { continue }
    guard let height = passport["hgt"], validHeight(height) else { continue }
    guard let hairColor = passport["hcl"], validHairColor(hairColor) else { continue }
    guard let eyeColor = passport["ecl"], validEyeColors.contains(eyeColor) else { continue }
    guard let pid = passport["pid"], isValidPassportId(pid) else { continue }

    valid2 += 1

}

print("valids", valids)
print("valid2", valid2)

