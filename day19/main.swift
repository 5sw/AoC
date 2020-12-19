import Foundation

let input = loadData(day: 19)
let scanner = Scanner(string: input)
scanner.charactersToBeSkipped = .whitespaces

enum Rule: Equatable {
    case character(Character)
    indirect case sequence(Rule, Rule)
    indirect case alternative(Rule, Rule)
    case reference(Int)
}


typealias RuleSet = [Int: Rule]

extension Scanner {
    func parseRuleSet() -> RuleSet {
        var result: [Int: Rule] = [:]
        while !string("\n") {
            guard let (index, rule) = parseRuleDefinition() else { fatalError() }
            result[index] = rule
        }

        return result
    }

    func parseRuleDefinition() -> (Int, Rule)? {
        guard let label = parseLabel(),
              let rule = parseRule(),
              string("\n")
        else { return nil }
        return (label, rule)
    }

    func parseLabel() -> Int? {
        guard let num = scanInt(),
              string(":")
        else { return nil }
        return num
    }

    func parseRule() -> Rule? {
        if string("\""), let character = scanCharacter(), string("\"") {
            return .character(character)
        }

        guard let sequence = parseSequence() else { return nil }

        if string("|"), let rhs = parseSequence() {
            return .alternative(sequence, rhs)
        }

        return sequence
    }

    func parseReference() -> Rule? {
        guard let num = scanInt() else { return nil }
        return .reference(num)
    }

    func parseSequence() -> Rule? {
        guard var sequence = parseReference() else {
            return nil
        }

        while let rhs = parseReference() {
            sequence = .sequence(sequence, rhs)
        }

        return sequence
    }
}

let rules = scanner.parseRuleSet()

extension Rule {
    func matches(rules: RuleSet, index: Int, _ s: Substring) -> Substring? {
        switch self {
        case .character(let ch):
            if s.first == ch {
                return s.dropFirst()
            }

            return nil

        case let .sequence(first, second):
            if let firstMatch = first.matches(rules: rules, index: index, s), let secondMatch = second.matches(rules: rules, index: index, firstMatch) {
                return secondMatch
            }

            return nil

        case .alternative(let a, .sequence(let b, .reference(index))) where a == b:
            var rest = s
            while let match = a.matches(rules: rules, index: index, rest) {
                rest = match
            }
            guard rest != s else { return nil }
            return rest
            
        case let .alternative(first, second):
            if let firstMatch = first.matches(rules: rules, index: index, s) {
                return firstMatch
            }

            if let secondMatch = second.matches(rules: rules, index: index, s) {
                return secondMatch
            }

            return nil

        case .reference(let index):
            return rules[index]!.matches(rules: rules, index: index, s)
        }
    }

    func matches(rules: RuleSet, index: Int, _ s: String) -> Bool {
        if let result = matches(rules: rules, index: index, s[...]), result.isEmpty {
            return true
        }

        return false
    }
}

extension Scanner {
    func scanLine() -> String? {
        guard let result = scanUpToCharacters(from: .newlines),
              scanCharacters(from: .newlines) != nil else {
            return nil
        }
        return result
    }

    func readLines() -> [String] {

        var lines = [String]()
        while let line = scanner.scanLine() {
            lines.append(line)
        }
        return lines
    }

}

let messages = scanner.readLines()

print("part 1", messages.lazy.filter { rules[0]!.matches(rules: rules,index: 0, $0) }.count)

let changedRules = """
8: 42 | 42 8
11: 42 31 | 42 11 31


"""

let changeScanner = Scanner(string: changedRules)
changeScanner.charactersToBeSkipped = .whitespaces
let ruleUpdates = changeScanner.parseRuleSet()

let newRules = rules.merging(ruleUpdates) { $1 }

print("part 2", messages.lazy.filter { rules[0]!.matches(rules: newRules, index: 0, $0) }.count)
