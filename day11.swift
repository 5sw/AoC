
struct Day11 {
    mutating func run() {
        var count = 0
        var currentStep = 0
        repeat {
            let stepCount = step()
            count += stepCount
            currentStep += 1
            if (currentStep == 100) {
                print("Part 1:", count)
            }

            if stepCount == width * height {
                print("Part 2:", currentStep)
                break
            }
        } while true
    }

    subscript(x: Int, y: Int) -> Int {
        get { data[x + width * y] }
        set { data[x + width * y] = newValue }
    }

    mutating func step() -> Int {
        var flashes: Set<Point> = []

        func up(x: Int, y: Int) {
            self[x, y] += 1
            if self[x, y] > 9, flashes.insert(Point(x: x, y: y)).inserted {
                for i in -1...1 where 0..<height ~= y + i {
                    for j in -1...1 where (i != 0 || j != 0) && 0..<width ~= x + j {
                        up(x: x + j, y: y + i)
                    }
                }
            }
        }

        for y in 0..<height {
            for x in 0..<width {
                up(x: x, y: y)
            }
        }

        for point in flashes {
            self[point.x, point.y] = 0
        }

        return flashes.count
    }

    struct Point: Hashable { var x: Int, y: Int }

    let width = 10
    let height = 10

    var data = [
        2, 5, 2, 4, 2, 5, 5, 3, 3, 1,
        1, 1, 3, 5, 6, 2, 5, 8, 8, 1,
        2, 8, 3, 8, 3, 5, 3, 8, 6, 3,
        1, 6, 6, 2, 3, 1, 2, 3, 6, 5,
        6, 8, 4, 7, 8, 3, 5, 8, 2, 5,
        2, 1, 8, 5, 6, 8, 4, 3, 6, 7,
        6, 8, 7, 4, 2, 1, 2, 8, 3, 1,
        5, 3, 8, 7, 2, 4, 7, 8, 1, 1,
        2, 2, 5, 5, 4, 8, 2, 8, 7, 5,
        8, 5, 2, 8, 5, 5, 7, 1, 3, 1,
    ]
}
