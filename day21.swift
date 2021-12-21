@main
struct Day21: Puzzle {
    func run() {
        part1()
    }

    func part1() {
        var die = Die()
        var player1 = Player(position: 6)
        var player2 = Player(position: 7)

        while true {
            if player1.move(die.roll3()) {
                print("Part 1: Player 1 won. ", die.rolls * player2.score)
                break
            }

            if player2.move(die.roll3()) {
                print("Part 1: Player 2 won. ", die.rolls * player1.score)
                break
            }
        }
    }

    struct Player {
        var position: Int
        var score: Int = 0

        mutating func move(_ roll: Int) -> Bool {
            position = 1 + (position + roll - 1) % 10
            score += position
            return score >= 1000
        }
    }

    struct Die {

    var rolls = 0
    var nextRoll = 1

    mutating func roll() -> Int {
        defer {
            rolls += 1
            nextRoll += 1
        }

        return nextRoll
    }

    mutating func roll3() -> Int {
        roll() + roll() + roll()
    }
    }

}
