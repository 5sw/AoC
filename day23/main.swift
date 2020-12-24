var stack = [9, 5, 2, 3, 1, 6, 4, 8, 7]

extension Array {
    mutating func rotateLeft(mid: Index) {
        let slice = self[0..<mid]
        removeSubrange(0..<mid)
        append(contentsOf: slice)
    }
}

func round() {
    let picked = stack[1 ... 3]
    stack.removeSubrange(1 ...  3)

    var destination = stack[0]
    repeat {
        destination -= 1
        if destination < 1 {
            destination = 9
        }
    } while picked.contains(destination)

    let destinationIndex = stack.firstIndex(of: destination)! + 1
    stack.insert(contentsOf: picked, at: destinationIndex)

    stack.rotateLeft(mid: 1)
}

func printStack() {
    for (offset, value) in stack.enumerated() {
        print(offset == 0 ? "(\(value))" : "\(value)", terminator: " ")
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

let oneIndex = stack.firstIndex(of: 1)!
stack.rotateLeft(mid: (oneIndex + 1) % stack.count)
print(stack.dropLast().map {"\($0)"}.joined())
