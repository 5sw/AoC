@main
struct Day12: Puzzle {
    func run() {
        let rooms = input.reduce(into: Set<String>()) { partialResult, pair in
            partialResult.insert(pair.0)
            partialResult.insert(pair.1)
        }.sorted()

        let small = Set(rooms.enumerated().compactMap { $0.element.first!.isLowercase ? $0.offset : nil })

        let matrix = buildMatrix(rooms, small: small)

        let startIndex = rooms.firstIndex(of: "start")!
        let endIndex = rooms.firstIndex(of: "end")!

        let paths = matrix.findPaths(from: startIndex, to: endIndex, continuing: Path())

        print("total paths", paths.count)
    }

    struct Path {
        var rooms: [Int] = []

        func appending(_ room: Int, small: Bool) -> Path? {
            guard !small || !rooms.contains(room) else {
                return nil
            }

            return Path(rooms: rooms + [room])
        }
    }

    struct Matrix {
        var data: [Bool]
        let size: Int
        let small: Set<Int>

        func neighbors(of index: Int) -> [Int] {
            let slice = data[index * size ..< (index + 1) * size]
            return slice.enumerated().compactMap { $0.element ? $0.offset : nil }
        }

        func findPaths(from: Int, to: Int, continuing: Path) -> [Path] {
            guard from != to else {
                return [continuing]
            }

            guard let current = continuing.appending(from, small: small.contains(from)) else {
                return  []               
            }

            return neighbors(of: from).reduce(into: []) { partialResult, next in
                partialResult += findPaths(from: next, to: to, continuing: current)
            }
        }
    }

    func buildMatrix(_ rooms: [String], small: Set<Int>) -> Matrix {
        let count = rooms.count
        var matrix = [Bool](repeating: false, count: count * count)

        for (from, to) in input {
            let fromIndex = rooms.firstIndex(of: from)!
            let toIndex = rooms.firstIndex(of: to)!

            matrix[fromIndex + count * toIndex] = true
            matrix[toIndex + count * fromIndex] = true
        }

        return Matrix(data: matrix, size: count, small: small)
    }


    let input: [(String, String)] = [
        ("rf", "RL"),
        ("rf", "wz"),
        ("wz", "RL"),
        ("AV", "mh"),
        ("end", "wz"),
        ("end", "dm"),
        ("wz", "gy"),
        ("wz", "dm"),
        ("cg", "AV"),
        ("rf", "AV"),
        ("rf", "gy"),
        ("end", "mh"),
        ("cg", "gy"),
        ("cg", "RL"),
        ("gy", "RL"),
        ("VI", "gy"),
        ("AV", "gy"),
        ("dm", "rf"),
        ("start", "cg"),
        ("start", "RL"),
        ("rf", "mh"),
        ("AV", "start"),
        ("qk", "mh"),
        ("wz", "mh"),
    ]
}
