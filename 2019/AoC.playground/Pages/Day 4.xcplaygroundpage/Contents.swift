let min = 172930
let max = 683082

var count = 0
outer: for i in min...max {
    let s = String(i).compactMap { $0.wholeNumberValue }

    var hasDouble = false

    for (first, second) in zip(s, s.dropFirst()) {
        if second < first {
            continue outer
        }

        if first == second {
            hasDouble = true
        }
    }

    guard hasDouble else { continue }

    count += 1
}
