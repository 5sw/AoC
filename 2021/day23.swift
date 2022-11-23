
@main
struct Day23: Puzzle {
    func run() {
        part1()
        part2()
    }

    func part1() {
        var board = Board(height: 3)
        board.fillHomeRow(for: .a, pieces: [.c, .c])
        board.fillHomeRow(for: .b, pieces: [.b, .d])
        board.fillHomeRow(for: .c, pieces: [.a, .a])
        board.fillHomeRow(for: .d, pieces: [.d, .b])
        board.show()
        print("Part 1:", find(start: board))
    }

    func part2() {
        var board = Board(height: 5)
        board.fillHomeRow(for: .a, pieces: [.c, .d, .d, .c])
        board.fillHomeRow(for: .b, pieces: [.b, .c, .b, .d])
        board.fillHomeRow(for: .c, pieces: [.a, .b, .a, .a])
        board.fillHomeRow(for: .d, pieces: [.d, .a, .c, .b])
        board.show()
        print("Part 2:", find(start: board))
    }

    func find(start: Board) -> Int {
        let target = Board.makeGoal(height: start.height)
        var current = start
        var totalCost = 0

        var possible: [Board: Int] = [:]
        var visited: Set<Board> = []


        while current != target {
            visited.insert(current)

            for (next, cost) in current.possibleMoves() where !visited.contains(next) {
                possible[next] = min(possible[next, default: .max], totalCost + cost)
            }

            (current, totalCost) = possible.min { $0.value < $1.value }!

            possible.removeValue(forKey: current)
        }

        return totalCost
    }

}

struct Board: Hashable {
    enum Piece: CaseIterable, Hashable, CustomStringConvertible {
        case a, b, c, d

        var homeColumn: Int {
            switch self {
            case .a:
                return 2
            case .b:
                return 4
            case .c:
                return 6
            case .d:
                return 8
            }
        }

        var cost: Int {
            switch self {
            case .a:
                return 1
            case .b:
                return 10
            case .c:
                return 100
            case .d:
                return 1000
            }
        }

        var sign: Character {
            switch self {
            case .a:
                return "A"
            case .b:
                return "B"
            case .c:
                return "C"
            case .d:
                return "D"
            }
        }

        var description: String { String(sign) }
    }
    enum Cell: Hashable {
        case piece(Piece)
        case empty
        case outside
    }

    var width = 11
    var height = 3

    var board: [Cell]

    init(height: Int) {
        self.height = height
        board = Array(repeating: .outside, count: width * height)
        for x in 0..<width {
            self[x, 0] = .empty
        }
    }

    mutating func fillHomeRow(for piece: Piece, pieces: [Piece]) {
        precondition(pieces.count == height - 1)
        let x = piece.homeColumn
        for (y, piece) in pieces.enumerated() {
            self[x, y + 1] = .piece(piece)
        }
    }

    static func makeGoal(height: Int) -> Self {
        var board = Self(height: height)
        for piece in Piece.allCases {
            for y in 1..<board.height {
                board[piece.homeColumn, y] = .piece(piece)
            }
        }
        return board
    }

    func movablePieces() -> [(Piece, Int, Int)] {
        var result: [(Piece, Int, Int)] = []
        for x in 0..<width {
            if case .piece(let piece) = self[x, 0] {
                result.append((piece, x, 0))
            }
        }

        for home in Piece.allCases {
            let x = home.homeColumn
            var y = 1
            while y < height, case .empty = self[x, y] {
                y += 1
            }
            if y < height, case let .piece(piece) = self[x, y] {
                result.append((piece, x, y))
            }
        }

        return result
    }

    func possibleMoves() -> [(Board, Int)] {
        let pieces = movablePieces()
            .filter { !isHome(piece: $0.0, x: $0.1, y: $0.2) }

        var result: [(Board, Int)] = []
        for (piece, x, y) in pieces {
            if let newY = freeHomeRowPosition(piece: piece), freeCorridor(from: x, to: piece.homeColumn) {
                result.append(move(piece: piece, from: (x, y), to: (piece.homeColumn, newY)))
            }

            for newX in openCorridorPositions(x: x) {
                result.append(move(piece: piece, from: (x, y), to: (newX, 0)))
            }
        }

        return result
    }

    func freeCorridor(from x0: Int, to x1: Int) -> Bool {
        let minX: Int
        let maxX: Int

        if x0 < x1 { (minX, maxX) = (x0 + 1, x1) }
        else { (minX, maxX) = (x1, x0 - 1) }

        for x in minX...maxX {
            if self[x, 0] != .empty {
                return false
            }
        }

        return true
    }

    func move(piece: Piece, from: (Int, Int), to: (Int, Int)) -> (Board, Int) {
        let (x, y) = from
        let (newX, newY) = to

        precondition(self[newX,newY] == .empty)

        let cost = (y + distance((x, 0), (newX, newY))) * piece.cost
        var board = self
        board[x, y] = .empty
        board[newX, newY] = .piece(piece)

        return (board, cost)
    }

    func freeHomeRowPosition(piece: Piece) -> Int? {
        let x = piece.homeColumn
        var depth = height - 1

    loop: while depth > 0 {
        switch self[x, depth] {
        case .piece(piece): break
        case .piece: return nil
        case .empty: break loop
        case .outside: preconditionFailure("Invalid board")
        }
        depth -= 1
    }

        return depth
    }

    static let homeColumns = Set(Piece.allCases.map(\.homeColumn))

    func openCorridorPositions(x: Int) -> [Int] {
        var xmin = x
        var xmax = x

        while xmin > 0 && self[xmin, 0] == .empty {
            xmin -= 1
        }

        while xmax < width && self[xmax, 0] == .empty {
            xmax += 1
        }

        let result = (xmin..<xmax).filter { !Self.homeColumns.contains($0) && self[$0,0] ==  .empty }
        return result
    }

    func distance(_ a: (Int, Int), _ b: (Int, Int)) -> Int {
        let (x0, y0) = a
        let (x1, y1) = b

        return abs(x1 - x0) + abs(y1 - y0)
    }

    func isHome(piece: Piece, x: Int, y: Int)  -> Bool {
        guard x == piece.homeColumn && y > 0 else { return false }
        for otherY in (y + 1)..<height {
            if self[x, otherY] != .piece(piece) {
                return false
            }
        }
        return true
    }

    func show() {
        print(String(repeating: "#", count: width + 2))
        for y in 0..<height {
            var line = ""
            for x in 0..<width {
                switch self[x, y] {
                case .outside:
                    line += "#"
                case .empty: line += "."
                case .piece(let piece): line.append(piece.sign)
                }
            }
            print("#\(line)#")
        }
        print(String(repeating: "#", count: width + 2))
    }

    subscript(x: Int, y: Int) -> Cell {
        get {
            board[x + width * y]
        }
        set {
            board[x + width * y] = newValue
        }
    }
}
