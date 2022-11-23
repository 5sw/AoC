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
    func matches(rules: RuleSet, _ s: Substring) -> Set<Substring> {
        switch self {
        case .character(let ch):
            if s.first == ch {
                return [s.dropFirst()]
            }

            return []

        case let .sequence(first, second):
            let firstMatches = first.matches(rules: rules, s)
            return Set(firstMatches.flatMap { second.matches(rules: rules, $0) })

        case let .alternative(first, second):
            let firstMatch = first.matches(rules: rules, s)
            let secondMatch = second.matches(rules: rules, s)

            return firstMatch.union(secondMatch)

        case .reference(let index):
            return rules[index]!.matches(rules: rules, s)
        }
    }

    func matches(rules: RuleSet, _ s: String) -> Bool {
        let result = matches(rules: rules, s[...])
        return result.contains("")
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

let start = Rule.reference(0)

print("part 1:", messages.lazy.filter { start.matches(rules: rules, $0) }.count)

let changedRules = """
8: 42 | 42 8
11: 42 31 | 42 11 31


"""

let changeScanner = Scanner(string: changedRules)
changeScanner.charactersToBeSkipped = .whitespaces
let ruleUpdates = changeScanner.parseRuleSet()

let newRules = rules.merging(ruleUpdates) { $1 }

print("part 2:", messages.filter { start.matches(rules: newRules, $0) }.count)
