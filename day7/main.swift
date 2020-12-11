import Foundation

let input = loadData(day: 7)


let scanner = Scanner(string: input)

struct Rule {
    var count: Int
    var color: String
}

extension Scanner {
    func scanRule() -> Rule? {
        guard let count = scanInt(),
              let color = scanUpToString(count == 1 ? " bag" : " bags"),
              scanString(count == 1 ? "bag" : "bags") != nil
              else { return nil }
        return Rule(count: count, color: color)
    }

    func scanRuleSet() -> (String, [Rule])? {
        guard
            let color = scanUpToString(" bags contain"),
            scanString("bags contain") != nil else { return nil }
        if scanString("no other bags.") != nil {
            return (color, [])
        }

        var rules: [Rule] = []
        repeat {
            guard let rule = scanRule() else { return nil }
            rules.append(rule)
        } while scanString(",") != nil

        guard scanString(".") != nil else { return nil }

        return (color, rules)
    }

    func scanAllRules() -> [String: [Rule]]? {
        var result: [String: [Rule]] = [:]
        while !isAtEnd {
            guard let (color, rules) = scanRuleSet() else { return nil }
            result[color] = rules
        }
        return result
    }
}

guard let rules = scanner.scanAllRules() else { fatalError() }
//print(rules)

func findPath(rules: [String: [Rule]], from: String, to: String) -> Bool {
    guard let from = rules[from] else { return false }
    if from.contains(where: { $0.color == to }) {
        return true
    }

    return from.contains(where: { findPath(rules: rules, from: $0.color, to: to) })
}

let count = rules.lazy.filter { findPath(rules: rules, from: $0.key, to: "shiny gold") }.count

print("count", count)

func bagsInside(rules: [String: [Rule]], color: String) -> Int {
    guard let from = rules[color] else { return 0 }
    return from.reduce(0) { accum, bag in
        accum + bag.count + bag.count * bagsInside(rules: rules, color: bag.color)
    }
}

print("total bags", bagsInside(rules: rules, color: "shiny gold"))
