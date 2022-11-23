import Foundation

let regex = try! NSRegularExpression(pattern: #"^([a-z]+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.$"#, options: [.caseInsensitive, .anchorsMatchLines])

struct Reindeer {
    var name: String
    var flySpeed: Int
    var flyDuration: Int
    var restDuration: Int

    var duration: Int
    var resting: Bool = false
    var distance: Int = 0
    var points: Int = 0

    mutating func step() {
        duration -= 1
        if !resting {
            distance += flySpeed
        }

        if duration == 0 {
            resting.toggle()
            duration = resting ? restDuration : flyDuration
        }
    }

    static func parse(_ input: String) -> [Reindeer] {
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        return matches.map { Reindeer(match: $0, in: input) }
    }

    init(match: NSTextCheckingResult, in string: String) {
        name = String(match.string(index: 1, in: string))
        flySpeed = Int(match.string(index: 2, in: string))!
        flyDuration = Int(match.string(index: 3, in: string))!
        restDuration = Int(match.string(index: 4, in: string))!

        duration = flyDuration
    }
}

extension NSTextCheckingResult {
    func string(index: Int, in string: String) -> Substring {
        let range = Range(self.range(at: index), in: string)!
        return string[range]
    }
}

let input = """
Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
Rudolph can fly 3 km/s for 15 seconds, but then must rest for 28 seconds.
Donner can fly 19 km/s for 9 seconds, but then must rest for 164 seconds.
Blitzen can fly 19 km/s for 9 seconds, but then must rest for 158 seconds.
Comet can fly 13 km/s for 7 seconds, but then must rest for 82 seconds.
Cupid can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
Dasher can fly 14 km/s for 3 seconds, but then must rest for 38 seconds.
Dancer can fly 3 km/s for 16 seconds, but then must rest for 37 seconds.
Prancer can fly 25 km/s for 6 seconds, but then must rest for 143 seconds.
"""


var group = Reindeer.parse(input)

for _ in 0..<2503 {
    for i in group.indices {
        group[i].step()
    }

    let lead = group.map(\.distance).max()!

    for i in group.indices where group[i].distance == lead {
        group[i].points += 1
    }
}

group

group
    .sorted { $0.points > $1.points }
    .first

