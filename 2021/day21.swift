@main
struct Day21: Puzzle {
    func run() {
        part1()
        part2()
    }
    let player1 = Player(position: 6)
    let player2 = Player(position: 7)

    func part1() {
        var die = Die()
        var player1 = player1
        var player2 = player2

        while true {
            if player1.move(die.roll3()) >= 1000 {
                print("Part 1: Player 1 won. ", die.rolls * player2.score)
                break
            }

            if player2.move(die.roll3()) >= 1000 {
                print("Part 1: Player 2 won. ", die.rolls * player1.score)
                break
            }
        }
    }

    func part2() {
        var universes: [Universe: Int] = [Universe(player1: player1, player2: player2): 1]
        var player1Wins = 0
        var player2Wins = 0
        while !universes.isEmpty {
            var newUniverses: [Universe: Int] = [:]
            for (universe, universeCount) in universes {
                for (offset, player1RollCount) in rollCounts.enumerated() {
                    var u = universe
                    if u.player1.move(offset + minRoll) >= quantumMax {
                        player1Wins += universeCount * player1RollCount
                        continue
                    }

                    for (offset, player2RollCount) in rollCounts.enumerated() {
                        var u2 = u
                        if u2.player2.move(offset + minRoll) >= quantumMax {
                            player2Wins += universeCount * player1RollCount * player2RollCount
                            continue
                        }

                        newUniverses[u2, default: 0] += universeCount * player1RollCount * player2RollCount
                    }
                }
            }

            universes = newUniverses
        }

        print("Part 2: ", max(player1Wins, player2Wins))
    }

    let quantumMax = 21

    let minRoll = 3
    //                3  4  5  6  7  8  9
    let rollCounts = [1, 3, 6, 7, 6, 3, 1]

    struct Universe: Hashable {
        var player1: Player
        var player2: Player
    }

    struct Player: Hashable {
        var position: Int
        var score: Int = 0

        mutating func move(_ roll: Int) -> Int {
            position = 1 + (position + roll - 1) % 10
            score += position
            return score
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
