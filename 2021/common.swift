import Foundation

protocol Puzzle {
    mutating func run()
    init()
}

extension Puzzle {
    static func main() {
        let start = Date()
        var instance = Self()
        instance.run()
        let duration = Date().timeIntervalSince(start)
        if duration > 1 {
            print(String(format: "Took %.2f s", duration))
        } else {
            print(String(format: "Took %.2f ms", 1000 * duration))
        }
    }
}

extension RangeReplaceableCollection {
    mutating func removeFirst(where predicate: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
}
