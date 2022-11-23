func step(_ input: String) -> String {
    var position = input.startIndex
    var output = ""
    while position < input.endIndex {
        let next = input[position...].firstIndex(where: { $0 != input[position] }) ?? input.endIndex

        let distance = input.distance(from: position, to: next)

        output += "\(distance)\(input[position])"

        position = next
    }

    return output
}

var current = "1321131112"
for _ in 0..<50 {
    current = step(current)
}
current
current.count

