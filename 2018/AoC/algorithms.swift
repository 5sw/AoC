import Foundation
func readInput() -> AnySequence<String> {
    return AnySequence {
        AnyIterator {
            readLine()
        }
    }
}

extension Sequence {
    func fold(initial: Element, operation: @escaping (Element, Element) -> Element) -> AnySequence<Element> {
        return AnySequence { () -> AnyIterator<Element> in
            var iterator: Iterator? = nil
            var runningSum = initial

            return AnyIterator {
                if iterator == nil {
                    iterator = self.makeIterator()
                    return runningSum
                }

                guard let next = iterator?.next() else {
                    return nil
                }

                runningSum = operation(runningSum, next)
                return runningSum
            }
        }
    }

    func repeated() -> AnySequence<Element> {

        return AnySequence(sequence(state: nil as Iterator?) { iterator in
            if let next = iterator?.next() {
                return next
            }

            iterator = self.makeIterator()
            return iterator?.next()
        })
    }
}

extension Sequence where Element: Hashable {
    func firstDuplicate() -> Element? {
        var items: Set<Element> = []
        return first { !items.insert($0).inserted }
    }
}


extension Sequence where Element: Hashable {
    func frequencies() -> [Element: Int] {
        return Dictionary(self.map { ($0, 1) }, uniquingKeysWith: { first, second in
            first + second
        })
    }
}

extension Sequence {
    func allPairs() -> AnySequence<(Element, Element)> {
        return AnySequence { () -> AnyIterator<(Element, Element)> in
            var pairIterator: Array<(Element, Element)>.Iterator? = nil
            var outerIterator = self.makeIterator()
            var drop = 1

            return AnyIterator { () -> (Element, Element)? in
                if let result = pairIterator?.next() {
                    return result
                }

                guard let value = outerIterator.next() else {
                    return nil
                }

                pairIterator = self.dropFirst(drop).lazy.map { (value, $0) }.makeIterator()
                drop += 1

                return pairIterator?.next()
            }
        }
    }
}
