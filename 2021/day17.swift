@main
struct Day17: Puzzle {
    func run() {
        var maxHeight: Int = 0
        var count = 0

        for speedX in 1..<300 {
            for speedY in -600..<300 {
                if case .hit(let height) = run(vx: speedX, vy: speedY) {
                    maxHeight = max(height, maxHeight)
                    count += 1
                }
            }
        }

        print("Part 1:", maxHeight)
        print("Part 2:", count)
    }

    enum Result {
        case tooFar
        case tooShort
        case hit(height: Int)
    }

    struct Vector: Hashable {
        var x: Int
        var y: Int
    }

    func run(vx: Int, vy: Int) -> Result {
        var state = State(vx: vx, vy: vy)
        while state.x <= xMax && state.y >= yMin {
            state.step()
            if xMin...xMax ~= state.x && yMin...yMax ~=  state.y {
                return .hit(height: state.maxHeight)
            }
        }

        if state.x > xMax {
            return .tooFar
        }

        return .tooShort
    }

    struct State {
        var vx: Int
        var vy: Int
        var x: Int = 0
        var y: Int = 0
        var maxHeight = 0

        mutating func step() {
            if y > maxHeight {
                maxHeight = y
            }

            x += vx
            y += vy
            vx -= vx.signum()
            vy -= 1
        }
    }

    // target area: x=138..184, y=-125..-71
    let xMin = 138
    let xMax = 184
    let yMin = -125
    let yMax = -71
}
