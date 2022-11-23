import Foundation



struct Claim {
    let id: Int
    let left: Int
    let top: Int
    let width: Int
    let height: Int

    var right: Int { return left + width }
    var bottom: Int { return top + height }
}

func overlap(_ first: Claim, _ second: Claim) -> (Int, Int, Int, Int)? {
    let overlapRight: Int = min(first.right, second.right)
    let overlapLeft: Int = max(first.left, second.left)
    let widthOverlap = overlapRight - overlapLeft
    let overlapBottom: Int = min(first.bottom, second.bottom)
    let overlapTop: Int = max(first.top, second.top)
    let heightOverlap = overlapBottom - overlapTop
    guard widthOverlap > 0 && heightOverlap > 0 else { return nil }
    return (overlapLeft, overlapTop, widthOverlap, heightOverlap)
}

extension Scanner {

    func scan() -> Claim? {
        guard
            scan(string: "#"),
            let id: Int = scan(),
            scan(string: "@"),
            let left: Int = scan(),
            scan(string: ","),
            let top: Int = scan(),
            scan(string: ":"),
            let width: Int = scan(),
            scan(string: "x"),
            let height: Int = scan()
        else {
            return nil
        }

        return Claim(id: id, left: left, top: top, width: width, height: height)
    }

    func readClaims() -> [Claim] {
        var result: [Claim] = []
        while !isAtEnd, let claim: Claim = scan() {
            result.append(claim)
        }
        return result
    }
}

let claims = Scanner(string:day3Input)
    .readClaims()
    .allPairs()
    .compactMap(overlap)
    //.reduce(0) { $0 + $1.0 * $1.1 }

print(claims)

//func removeDifferingCharacter(_ a: String, _ b: String) -> String? {
//    var differingIndex: Int? = nil
//    for (index, (first, second)) in zip(a,b).enumerated() {
//        if first == second {
//            continue
//        }
//
//        if differingIndex != nil {
//            return nil
//        }
//
//        differingIndex = index
//    }
//
//    guard let offset = differingIndex, let index = a.index(a.startIndex, offsetBy: offset, limitedBy: a.endIndex) else { return nil }
//
//    return String(a[a.startIndex..<index]) + a[a.index(after: index)..<a.endIndex]
//}
//
//print(Array(readInput())
//    .allPairs()
//    .compactMap(removeDifferingCharacter))

//let frequencies = readInput()
//    .map { $0.frequencies() }
//    .reduce(into: (0, 0)) { result, frequencies in
//        print(frequencies);
//        if frequencies.contains(where: { _, count in count == 2 }) {
//            print("double")
//            result.0 += 1
//        }
//
//        if frequencies.contains(where: { _, count in count == 3 }) {
//            print("triple")
//            result.1 += 1
//        }
//    }


//let firstDuplicate = readInput()
//    .compactMap(Int.init)
//    .repeated()
//    .fold(initial: 0, operation: +)
//    .firstDuplicate()
//
//if let x = firstDuplicate { print(x) }

