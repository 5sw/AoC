import Foundation

let input = loadData(day: 9)
let scanner = Scanner(string: input)

let numbers = scanner.integers()!

var weakness: Int? = nil
outer: for i in 25..<numbers.count {
    let search = numbers[i]

    for j in (i - 25)..<i {
        for k in j..<i {
            if search == numbers[j] + numbers[k] {
                continue outer
            }
        }
    }

    print("first which is not sum", i, search)
    weakness = search
    break
}


guard let weakness = weakness else { fatalError("No weakness found") }

outer: for i in 0..<numbers.count {
    var sum = 0
    var min = Int.max
    var max = Int.min
    for j in (i+1)..<numbers.count {
        let n = numbers[j]
        sum += n
        if n < min { min = n }
        if n > max { max = n }
        if sum == weakness {
            print(min + max)
            break outer
        }
        if sum > weakness {
            break
        }
    }
}
