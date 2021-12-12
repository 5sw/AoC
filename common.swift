protocol Puzzle {
    mutating func run()
    init()
}

extension Puzzle {
    static func main() {
        var instance = Self()
        instance.run()
    }
}

extension RangeReplaceableCollection {
    mutating func removeFirst(where predicate: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
}
