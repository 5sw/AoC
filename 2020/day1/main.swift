import Foundation

let input = Scanner(string: loadData(day: 1)).integers()

for i in 0..<input.count {
    for j in i..<input.count   {
        for k in j..<input.count {
            let a = input[i]
            let b = input[j]
            let c = input[k]

            if k == j && a + b == 2020 {
                print("1st", a * b)
            }

            if a + b + c == 2020 {
                print("2nd", a * b * c)
            }
        }
    }
}
