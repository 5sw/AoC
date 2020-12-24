class Node {
    var next: Node!
    var value: Int

    init(value: Int, next: Node? = nil) {
        self.value = value
        self.next = next
    }

    static func make(_ values: [Int]) -> Node {
        precondition(!values.isEmpty)

        let first = Node(value: values[0])
        first.next = first

        var current = first
        for value in values.dropFirst() {
            let new = Node(value: value, next: first)
            current.next = new
            current = new
        }

        return first
    }

    func find(value: Int) -> Node? {
        var current = self
        repeat {
            if current.value == value {
                return current
            }
            current = current.next
        } while current !== self
        return nil
    }
}


let input = [9, 5, 2, 3, 1, 6, 4, 8, 7]
let max = input.max()!

let node = Node.make(input)
var selected = node

func rangeContains(value: Int, start: Node,  end: Node) -> Bool {
    var current = start
    while current !== end.next {
        if current.value == value {
            return true
        }
        current = current.next
    }
    return false
}

func round() {
    let firstPick: Node = selected.next
    let lastPick: Node = firstPick.next.next

    selected.next = lastPick.next

    var destination = selected.value
    repeat {
        destination -= 1
        if destination < 1 {
            destination = max
        }
    } while rangeContains(value: destination, start: firstPick, end: lastPick)

    let toInsert = lastPick.next.find(value: destination)!
    lastPick.next = toInsert.next
    toInsert.next = firstPick

    selected = selected.next
}

func printStack() {
    var current = node
    repeat {
        print(current === selected ? "(\(current.value))" : "\(current.value)", terminator: " ")
        current = current.next
    } while current !== node
    print()
}

func showSolution() {
    let start = node.find(value: 1)!
    var one: Node = start.next
    while one !== start {
        print(one.value, terminator: "")
        one = one.next
    }
    print()

}

for i in 0..<100 {
    print("\(i + 1)) ", terminator: "")
    printStack()
    round()
}

print("Final: ", terminator: "")
printStack()
showSolution()
