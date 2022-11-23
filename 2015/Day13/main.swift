import Foundation

let input = """
Alice would lose 2 happiness units by sitting next to Bob.
Alice would lose 62 happiness units by sitting next to Carol.
Alice would gain 65 happiness units by sitting next to David.
Alice would gain 21 happiness units by sitting next to Eric.
Alice would lose 81 happiness units by sitting next to Frank.
Alice would lose 4 happiness units by sitting next to George.
Alice would lose 80 happiness units by sitting next to Mallory.
Bob would gain 93 happiness units by sitting next to Alice.
Bob would gain 19 happiness units by sitting next to Carol.
Bob would gain 5 happiness units by sitting next to David.
Bob would gain 49 happiness units by sitting next to Eric.
Bob would gain 68 happiness units by sitting next to Frank.
Bob would gain 23 happiness units by sitting next to George.
Bob would gain 29 happiness units by sitting next to Mallory.
Carol would lose 54 happiness units by sitting next to Alice.
Carol would lose 70 happiness units by sitting next to Bob.
Carol would lose 37 happiness units by sitting next to David.
Carol would lose 46 happiness units by sitting next to Eric.
Carol would gain 33 happiness units by sitting next to Frank.
Carol would lose 35 happiness units by sitting next to George.
Carol would gain 10 happiness units by sitting next to Mallory.
David would gain 43 happiness units by sitting next to Alice.
David would lose 96 happiness units by sitting next to Bob.
David would lose 53 happiness units by sitting next to Carol.
David would lose 30 happiness units by sitting next to Eric.
David would lose 12 happiness units by sitting next to Frank.
David would gain 75 happiness units by sitting next to George.
David would lose 20 happiness units by sitting next to Mallory.
Eric would gain 8 happiness units by sitting next to Alice.
Eric would lose 89 happiness units by sitting next to Bob.
Eric would lose 69 happiness units by sitting next to Carol.
Eric would lose 34 happiness units by sitting next to David.
Eric would gain 95 happiness units by sitting next to Frank.
Eric would gain 34 happiness units by sitting next to George.
Eric would lose 99 happiness units by sitting next to Mallory.
Frank would lose 97 happiness units by sitting next to Alice.
Frank would gain 6 happiness units by sitting next to Bob.
Frank would lose 9 happiness units by sitting next to Carol.
Frank would gain 56 happiness units by sitting next to David.
Frank would lose 17 happiness units by sitting next to Eric.
Frank would gain 18 happiness units by sitting next to George.
Frank would lose 56 happiness units by sitting next to Mallory.
George would gain 45 happiness units by sitting next to Alice.
George would gain 76 happiness units by sitting next to Bob.
George would gain 63 happiness units by sitting next to Carol.
George would gain 54 happiness units by sitting next to David.
George would gain 54 happiness units by sitting next to Eric.
George would gain 30 happiness units by sitting next to Frank.
George would gain 7 happiness units by sitting next to Mallory.
Mallory would gain 31 happiness units by sitting next to Alice.
Mallory would lose 32 happiness units by sitting next to Bob.
Mallory would gain 95 happiness units by sitting next to Carol.
Mallory would gain 91 happiness units by sitting next to David.
Mallory would lose 66 happiness units by sitting next to Eric.
Mallory would lose 75 happiness units by sitting next to Frank.
Mallory would lose 99 happiness units by sitting next to George.
"""

let regex = try! NSRegularExpression(pattern: #"^([a-z]+) would (gain|lose) (\d+) happiness units by sitting next to ([a-z]+)\.$"#, options: [.anchorsMatchLines, .caseInsensitive])

let matches = regex.matches(in: input, options: [])

var scores: [Substring: [Substring: Int]] = [:]

for match in matches {
    let parts = match.matches(in: input)
    let personA = parts[1]
    let sign = parts[2] == "gain" ? 1 : -1
    let points = sign * Int(parts[3])!
    let personB = parts[4]

    scores[personA, default: [:]][personB] = points
}

func scoreFor(_ a: Substring, _ b: Substring) -> Int {
    if a == "me" || b == "me" {
        return 0
    }

    return scores[a]![b]! + scores[b]![a]!
}

extension Collection where Element: Equatable {
    func permutations() -> [[Element]] {
        if count == 0 {
            return []
        }

        if count == 1 {
            return [[self[self.startIndex]]]
        }

        var result: [[Element]] = []
        for element in self {
            let rest = self.filter { $0 != element }
            result.append(contentsOf: rest.permutations().map {
                [element] + $0
            })
        }

        return result
    }
}

func calculateScore(_ order: [Substring]) -> Int {
    var current = order.first!
    var score = 0
    for next in order.dropFirst() {
        score += scoreFor(current, next)
        current = next
    }
    score += scoreFor(current, order.first!)
    return score
}

let maxScore = scores.keys.permutations().map {
    calculateScore($0)
}.max()!

print(maxScore)

let maxScoreWithMe = (["me"] + Array(scores.keys)).permutations().map {
    calculateScore($0)
}.max()!

print("Including me:", maxScoreWithMe)

extension NSRegularExpression {
    func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        let range = NSRange(string.startIndex..., in: string)
        return matches(in: input, options: options, range: range)
    }
}

extension NSTextCheckingResult {
    struct Matches: BidirectionalCollection {
        typealias Element = Substring

        struct Index: Comparable {
            let position: Int

            static func <(lhs: Index, rhs: Index) -> Bool {
                return lhs.position < rhs.position
            }

        }

        func index(after i: Index) -> Index {
            Index(position: i.position + 1)
        }

        func index(before i: Index) -> Index {
            Index(position: i.position - 1)
        }


        let result: NSTextCheckingResult
        let wholeString: String

        var startIndex: Index { Index(position: 0) }
        var endIndex: Index { Index(position: result.numberOfRanges) }

        subscript(position: Index) -> Element {
            let range = Range(result.range(at: position.position), in: wholeString)!
            return wholeString[range]
        }

        subscript(name: String) -> Element? {
            let range = result.range(withName: name)
            guard range.lowerBound != NSNotFound, let range = Range(range, in: wholeString) else { return nil }
            return wholeString[range]
        }
    }

    func matches(in string: String) -> Matches {
        .init(result: self, wholeString: string)
    }
}

extension NSTextCheckingResult.Matches.Index: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.position = value
    }

}
