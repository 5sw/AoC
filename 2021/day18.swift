import Foundation

@main
struct Day18: Puzzle {
    func run() {
        let pairs = Scanner(string: input).all()
        let first = pairs[0]
        let result = pairs.dropFirst().reduce(first, +)
        print(result.toString())
        print("Part 1:", result.magnitude())

        var largest = 0
        for a in pairs {
            for b in pairs where a !== b {
                largest = max(largest, (a + b).magnitude())
                largest = max(largest, (b + a).magnitude())
            }
        }
        print("Part 2:", largest)
    }
}

extension Scanner {
    func pair() -> Pair? {
        guard scanString("[") != nil else { return nil }
        guard let leftPart = part() else { return nil }
        guard scanString(",") != nil else { return nil }
        guard let rightPart = part() else { return nil }
        guard scanString("]") != nil else { return nil }
        return Pair(leftPart, rightPart)
    }

    func part() -> Number? {
        if let digits = scanInt() {
            return Regular(value: digits)
        }

        return pair()
    }

    func all() -> [Pair] {
        var result: [Pair] = []
        while let pair = self.pair() {
            result.append(pair)
        }
        assert(isAtEnd)
        return result
    }
}

struct ExplodeContext {
    var lastRegular: Regular? = nil
    var addToNextNumber: Int? = nil
    var didExplode = false
}

enum Action {
    case goOn
    case stop
    case replace(Number)
}

protocol Number: AnyObject {
    func toString() -> String

    func visitExplode(depth: Int, context: inout ExplodeContext) -> Action
    func visitSplit(didSplit: inout Bool) -> Action

    func magnitude() -> Int

    func copy() -> Number
}

extension Number where Self == Pair {
    static func parse(_ string: String) -> Self {
        Scanner(string: string).pair()!
    }
}

class Regular: Number {
    var value: Int

    init(value: Int) {
        self.value = value
    }

    func toString() -> String {
        "\(value)"
    }

    func visitExplode(depth: Int, context: inout ExplodeContext) -> Action {
        if let add = context.addToNextNumber {
            value += add
            return .stop
        }

        context.lastRegular = self
        return .goOn
    }

    func visitSplit(didSplit: inout Bool) -> Action {
        if value >= 10 {
            let first = value / 2
            didSplit = true
            return .replace(Pair(Regular(value: first), Regular(value: value - first)))
        }

        return .goOn
    }

    func magnitude() -> Int {
         value
    }

    func copy() -> Number { Regular(value: value) }

}

class Pair: Number {
    var left: Number
    var right: Number

    init(_ left: Number, _ right: Number) {
        self.left = left
        self.right = right
    }

    func toString() -> String {
        "[\(left.toString()), \(right.toString())]"
    }

    func splitFirst() -> Bool {
        var didSplit = false
        _ = visitSplit(didSplit: &didSplit)
        return didSplit
    }

    func explodeFirst() -> Bool {
        var context = ExplodeContext()
        _ = visitExplode(depth: 0, context: &context)
        return context.didExplode
    }

    func reduce() -> Pair {
        while true {
            if explodeFirst() { continue }
            if splitFirst() { continue }
            break
        }

        return self
    }

    func visitExplode(depth: Int, context: inout ExplodeContext) -> Action {
        if !context.didExplode && depth == 4 {
            context.lastRegular?.value += (left as! Regular).value
            context.addToNextNumber = (right as! Regular).value
            context.didExplode = true
            return .replace(Regular(value: 0))
        }


        switch left.visitExplode(depth: depth + 1, context: &context) {
        case .goOn:
            break
        case .stop:
            return .stop
        case .replace(let number):
            left = number
            break
        }

        let result = right.visitExplode(depth: depth + 1, context: &context)
        switch result {
        case .goOn:
            return .goOn
        case .stop:
            return .stop
        case .replace(let number):
            right = number
            return .goOn
        }

    }

    func visitSplit(didSplit: inout Bool) -> Action {
        switch left.visitSplit(didSplit: &didSplit) {
        case .goOn: break
        case .stop: return .stop
        case .replace(let new):
            left = new
            return .stop
        }

        switch right.visitSplit(didSplit: &didSplit) {
        case .goOn: return .goOn
        case .stop: return .stop
        case .replace(let new):
            right = new
            return .stop
        }
    }

    func magnitude() -> Int {
        3 * left.magnitude() + 2 * right.magnitude()
    }

    func copy() -> Number {
        Pair(left.copy(), right.copy())
    }
}

func +(lhs: Number, rhs: Number) -> Pair {
    Pair(lhs.copy(), rhs.copy()).reduce()
}

let input = """
[4,[3,[9,[9,0]]]]
[[[7,6],[2,[2,5]]],[5,[[7,3],8]]]
[4,[4,6]]
[[0,[5,6]],[[[1,3],[2,7]],[[0,6],4]]]
[6,[[3,[6,0]],3]]
[[7,[9,[8,5]]],[6,7]]
[[[[2,6],1],2],[3,[8,4]]]
[4,[[[5,4],[2,7]],[[8,0],[2,3]]]]
[[[[4,3],2],[[3,6],[2,5]]],[[[3,7],8],0]]
[[[8,[0,7]],1],[[9,[3,9]],9]]
[[[[3,0],[1,3]],[[0,9],8]],[[[7,2],9],[[1,4],[3,5]]]]
[[[[9,6],[4,4]],[1,3]],[[4,3],[[6,4],[8,4]]]]
[[[1,2],[[7,6],[2,3]]],[[4,6],[4,2]]]
[[[4,8],[[5,8],1]],[2,3]]
[[[5,2],[3,[5,7]]],[[2,9],5]]
[[[6,[3,2]],[2,6]],[[8,[4,2]],[[5,2],7]]]
[[[[2,6],[0,1]],[7,[3,6]]],[[1,6],[[7,9],0]]]
[[[0,3],[8,1]],[[[9,0],3],[0,2]]]
[[8,[[7,1],[4,7]]],[[0,[1,3]],[8,2]]]
[[[[2,3],4],[[0,8],[9,0]]],[1,[[5,3],4]]]
[[[[7,2],2],[[1,3],[8,3]]],[4,[[7,9],[0,6]]]]
[[[[2,2],[3,4]],[[1,5],[4,3]]],[6,[[7,2],1]]]
[1,[[[5,7],0],[9,[8,8]]]]
[[[[9,2],[0,9]],[4,[7,8]]],[[4,8],[[1,8],[4,9]]]]
[[[[4,7],2],2],4]
[1,[[2,[4,2]],1]]
[[[[7,2],[3,8]],[0,[1,3]]],[[[4,4],[2,4]],[8,2]]]
[[[[1,0],[0,5]],2],[[9,[5,0]],[[1,6],5]]]
[4,[[[8,1],[1,4]],[7,[1,3]]]]
[[[6,[0,4]],[[4,6],[2,4]]],[9,[1,5]]]
[[[[3,6],[3,3]],1],[0,[[8,8],2]]]
[[7,[5,[2,6]]],[[[7,9],6],[0,[3,6]]]]
[[[[6,7],4],[[2,9],2]],3]
[[[7,[1,7]],[5,4]],[[[1,1],[0,1]],5]]
[[6,[[1,0],6]],[0,[6,[0,5]]]]
[[[[2,4],[4,6]],9],[4,[[8,0],7]]]
[[[[9,9],[5,7]],[9,[8,6]]],[[3,[2,3]],0]]
[[0,[1,[5,3]]],[3,[8,[3,4]]]]
[[[[4,3],8],[2,9]],[[1,[6,5]],[[5,7],2]]]
[[[0,[7,4]],[9,[9,6]]],[[8,[5,5]],[[6,4],1]]]
[[[[7,3],[7,9]],[8,[6,2]]],[[8,[4,5]],[[6,4],[6,7]]]]
[[7,[[9,0],[9,0]]],[[[0,8],2],[8,[8,3]]]]
[4,[7,[5,6]]]
[7,[[[3,8],8],3]]
[[[4,[6,6]],0],[9,0]]
[[[[7,4],8],8],[[0,1],[[0,0],[2,4]]]]
[7,[1,[[9,4],[3,6]]]]
[[[[2,8],9],[[8,6],[2,2]]],[[[5,1],9],[2,[0,7]]]]
[8,7]
[[[[0,8],4],[[9,9],[9,9]]],[[[4,3],[1,0]],[6,8]]]
[[[[8,3],[8,9]],1],[[4,[1,0]],[[4,0],[2,3]]]]
[[[[4,7],[1,3]],[6,9]],[[1,0],[[1,8],5]]]
[[2,[4,[6,5]]],[3,[[9,9],5]]]
[[[[7,6],4],9],[8,[4,5]]]
[[[0,[6,6]],[7,[8,9]]],[[[0,0],[3,4]],[4,[1,8]]]]
[[[9,[7,0]],[5,8]],[6,[[5,0],[0,6]]]]
[[[[4,0],[1,9]],[7,[3,6]]],[[2,[8,6]],[[2,8],[8,2]]]]
[[[9,6],8],[[[5,5],[4,8]],0]]
[[[[1,7],1],2],[[[6,8],3],[[3,3],5]]]
[3,[5,[[3,8],6]]]
[3,[[[9,6],[5,8]],[9,2]]]
[[6,1],[6,4]]
[[2,6],[[[1,2],2],8]]
[[[[1,7],[3,6]],[2,[0,2]]],[[3,0],9]]
[1,[[0,[4,9]],5]]
[[[[5,5],[5,2]],[0,[6,4]]],8]
[0,[7,[[6,9],[6,0]]]]
[[[[2,2],[4,7]],[[7,4],6]],[[0,[1,7]],[[3,2],6]]]
[[9,8],0]
[[[[5,4],[4,8]],2],[3,[8,9]]]
[[[[7,0],8],5],[2,6]]
[[[5,[0,8]],5],[[[5,0],[1,8]],[[0,2],7]]]
[[[[9,4],8],[[6,5],4]],[[5,[8,9]],[4,[0,4]]]]
[[[[3,6],7],[[9,3],7]],[7,[[8,3],9]]]
[[[[0,7],5],[[5,7],2]],[[2,[9,5]],[[7,7],[5,0]]]]
[[[[7,5],2],[8,6]],[[2,[6,2]],[5,[3,1]]]]
[[9,[9,1]],6]
[[[0,7],[[5,9],2]],3]
[[[9,3],[8,8]],[0,[4,5]]]
[[[[6,2],5],[4,[3,1]]],[9,[2,8]]]
[[[1,[9,4]],[[0,0],2]],[[1,[2,1]],[[7,8],[3,2]]]]
[[[[0,6],[8,9]],[[4,7],[5,6]]],[[[1,4],[8,7]],[4,6]]]
[[[[6,4],[1,5]],[0,8]],[[[9,7],[1,2]],[9,4]]]
[[[[4,5],[0,7]],[9,[1,8]]],[[[5,0],6],7]]
[[[0,[6,9]],[5,[5,6]]],7]
[[4,5],[[7,[6,5]],1]]
[[[7,9],[6,7]],[4,1]]
[[[[9,6],1],[[3,1],[9,7]]],[1,[7,1]]]
[[[0,[2,0]],5],[[8,[7,6]],[[7,3],4]]]
[[[6,[1,7]],[9,[2,7]]],3]
[[[6,[8,2]],5],[4,[[1,3],[5,1]]]]
[[[4,[3,3]],[4,[2,4]]],[5,4]]
[[[1,6],[4,[4,0]]],[[8,[2,2]],[[8,1],[4,7]]]]
[[2,0],[[2,1],[[4,8],[2,7]]]]
[9,[[8,4],0]]
[[1,6],[[5,[1,3]],[9,[0,9]]]]
[[[0,[3,5]],3],[[2,[8,0]],[[2,0],[4,3]]]]
[[[1,[1,9]],[9,[7,9]]],[[2,2],[[6,7],[0,7]]]]
[[[4,6],[[6,2],[0,9]]],[[1,0],[1,[6,7]]]]
[9,[[[0,1],4],[[9,3],3]]]
"""
