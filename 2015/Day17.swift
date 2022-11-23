let input = [
    43,
    3,
    4,
    10,
    21,
    44,
    4,
    6,
    47,
    41,
    34,
    17,
    17,
    44,
    36,
    31,
    46,
    9,
    27,
    38,
]

var minLength = Int.max
var minCount = 0

func combinations(input: [Int], goal: Int, match: [Int] = []) -> Int {
    if goal == 0 {
        print("Found", match)
        
        if match.count < minLength {
            minLength = match.count
            minCount = 1
        } else if match.count == minLength {
            minCount += 1
        }
        
        return 1
    }
    
    guard !input.isEmpty else {
        return 0
    }
    
    var result = 0
    for (index, value) in input.enumerated() {
        if value <= goal {
            var next = Array(input[(index + 1)...])
            result += combinations(input: next, goal: goal - value, match: match + [value])
        }
    }
    return result
}

print(combinations(input: input.sorted(by: >), goal: 150))

print(minCount)