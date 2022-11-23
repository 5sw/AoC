let input = loadData(day: 3).lines()

/// - returns true if a tree is at that position, false if it is empty
func get(x: Int, y: Int) -> Bool {
    let line = input[y]
    let index = line.index(line.startIndex, offsetBy: x % line.count)
    return line[index] == "#"
}

func calculate(dx: Int, dy: Int) -> Int {
var x = 0
var y = 0

var trees = 0

while y < input.count {
    if get(x: x, y: y) {
        trees += 1
    }

    x += dx
    y += dy
}

    return trees
}

let trees = calculate(dx: 3, dy: 1)
print("trees", trees)


print("combined", calculate(dx: 1, dy: 1) * calculate(dx: 3, dy: 1) * calculate(dx: 5, dy: 1) * calculate(dx: 7, dy: 1) * calculate(dx: 1, dy: 2))
