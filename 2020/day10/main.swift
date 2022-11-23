import Foundation

let input = loadData(day: 10)
let scanner = Scanner(string: input)

var adapters = scanner.integers().sorted { $0 > $1 }
adapters.append(0)


let device = adapters[0] + 3

var current = device
var ones = 0
var threes = 0

for adapter in adapters {
    let step = current - adapter
    if step == 3 {
        threes += 1
    } else if step == 1 {
        ones += 1
    } else if step != 2 {
        print("fail")
    }
    current = adapter
}

print("part 1", ones * threes)

struct Key: Hashable {
    var start: Int
    var max: Int
}
var memo: [Key: Int] = [:]

func findPaths(start: Int, max: Int) -> Int {
    if let value = memo[Key(start: start, max: max)] {
        return value
    }

    let diff = max - adapters[start]
    if diff > 3 || diff < 1 {
        return 0
    }

    if start == adapters.count - 1 {
        return 1
    }

    var result = 0
    for n in (start + 1)..<(adapters.count) {
        let next = findPaths(start: n, max: adapters[start])
        if next == 0 {
            break
        }
        result += next
    }

    memo[Key(start: start, max: max)] = result

    return result
}

print(findPaths(start: 0, max: device))
