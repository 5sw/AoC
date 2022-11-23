import Foundation
let data = loadData(day: 22)
let scanner = Scanner(string: data)


guard scanner.string("Player 1:") else { fatalError() }
let p1 = scanner.integers()
var player1Deck = p1

guard scanner.string("Player 2:") else { fatalError() }
let p2 = scanner.integers()
var player2Deck = p2

assert(player1Deck.count == player2Deck.count)

while !player1Deck.isEmpty && !player2Deck.isEmpty {
    let a = player1Deck.removeFirst()
    let b = player2Deck.removeFirst()

    if a > b {
        player1Deck.append(contentsOf: [a, b])
    } else {
        player2Deck.append(contentsOf: [b, a])
    }
}

func calculateScore(_ deck: [Int]) -> Int {
    deck.reversed().enumerated().reduce(0) { $0 + $1.element * ($1.offset + 1) }
}

if player2Deck.isEmpty {
    print("Player 1 wins", calculateScore(player1Deck))
} else {
    print("Player 2 wins", calculateScore(player2Deck))
}

struct PlayedDeck: Hashable {
    let player1: [Int]
    let player2: [Int]
}
var playedDecks: Set<PlayedDeck> = []


func playGame(deck1: [Int], deck2: [Int])  -> (winner: Bool, score: Int) {
    var deck1 = deck1
    var deck2 = deck2
    var playedDecks: Set<PlayedDeck> = []

    while !deck1.isEmpty && !deck2.isEmpty {
        if !playedDecks.insert(PlayedDeck(player1: deck1, player2: deck2)).inserted {
            return (true, calculateScore(deck1))
        }
        playRound(deck1: &deck1, deck2: &deck2)
    }

    let winner = deck2.isEmpty
    return (winner, winner ? calculateScore(deck1) : calculateScore(deck2))
}

func playRound(deck1: inout [Int], deck2: inout [Int]) {
    let a = deck1.removeFirst()
    let b = deck2.removeFirst()

    let winner: Bool
    if a <= deck1.count && b <= deck2.count {
        winner = playGame(deck1: Array(deck1[0..<a]), deck2: Array(deck2[0..<b])).winner
    } else {
        winner = a > b
    }

    if winner {
        deck1.append(contentsOf: [a, b])
    } else {
        deck2.append(contentsOf: [b, a])
    }
}


player1Deck = p1
player2Deck = p2

    let (winner, score) = playGame(deck1: p1, deck2: p2)
    if winner {
        print("Player 1 wins", score)
    } else {
        print("Player 2 wins", score)
    }
