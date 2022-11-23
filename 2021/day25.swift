@main struct Day25: Puzzle {
    func run() {
        var current = input
        var stepCount = 0
        while true {
            let (next1, count1) = step(.right, input: current)
            let (next2, count2) = step(.down, input: next1)

            stepCount += 1
            current = next2

            if count1 + count2 == 0 {
                break
            }
        }
        print("Part 1: ", stepCount)
    }
}

func step(_ space: Space, input: [Space]) -> ([Space], Int) {
    var result: [Space] = input

    var count = 0
    for y in 0..<height {
        for x in 0..<width where input[x, y] == space {
            let tx = (x + space.dx) % width
            let ty = (y + space.dy) % height

            if input[tx, ty] == .empty {
                result[tx, ty] = space
                result[x, y] = .empty
                count += 1
            }
        }
    }

    return (result, count)
}

extension Array {
    subscript(x: Int, y: Int) -> Element {
        get {
            self[x + width * y]
        }

        set {
            self[x + width * y] = newValue
        }
    }
}

enum Space: Character {
    case right = ">"
    case down = "v"
    case empty = "."

    var dx: Int { self == .right ? 1 : 0 }
    var dy: Int { self == .down ? 1 : 0 }
}

let width = 139
let height = 137

let input = """
>>vv..>v..>vv.....>vv...>.>...>>......v>v>.v.v..>v..v>.>v.....v..>vvvv.>.>vv>v..v>.v>..v>>>>.>vv.>>vv>.>>v..>.v.v>v>v.>vv.>.......vv.>.>>v.
v>.>v>.v....>>v.vvv>.>>..>....>.v>.v>vv.v..v.v..v>.>.v>.>..>>v.vvvvv..>>..v.v..>>v>vv>.v..vvv.>v..v>>>v.v..>>...>vv..>>v.v>>.>v>.>.v....>>.
v.>vv....v>..v>>..v.>>.....vv..>.vvv>.....v.v>vvv>..v>>..v...>...>...vv.v..>.vvv>>.v>vv..v.>>>....vv.>.>..v..vv.>>v>.>>.>>.v>>>>.>v.v.>v..v
.v.>>..v...v>v.>>>>v....>.....>...v.v..>.v...>.v.....>>.v>v...>.>.>..>v>>>>.v.>..>......>.v>>.>v..>.>vv.>.v>...v.>v.>>.>...>>>..>>>.vv>..v.
.....v.>.v>........>>.>.>vvv.vv>>.>vvv.v.>vvv.....v..>v..>vvv.>.v>.>..v..vv.>...v>>>>vv>.v..v.>..>..vvvv.>.>vvv....v>..>...v...v.v>v.>..v.v
>..>..>..v.>>..v>..vv....>vv.vv>..>v........>..vv>.>.v.>...v.>v...vvv>.....v..vv...vv>.......v>vv.vv.>.vv..v>..v.v.>..>>>.v..vv>...v>vv..>v
.v.>..vv>.>>v>...>.>.>..>.vvv..v>v.v>>.v...v.vv..v..vvv..vv.v.vv...>v..v....>>>>..vvv>v..>.vv.v.>...>vv>......v...>.v...v....v....>v>.>>...
>v.v.v>>.v.>..>>v>>>v.>v.....v>...>>..v.v>.v..>>..>.vvv...>...v>>v.v....v>.vv>.>.v>.>>>.v>>.v..vvv>.vv......v.v...v...>.vvvvv>.>..>>...vv>.
vv>..v.>>v.>.>v.>..v.v>....vv.v..>>.>>v>>..>>>>v>..v>.>.>.>......vv>vv>>>v....>.>v..>.>>vv...>>v.....>>>....>.v.v>v>..v>v.>vv.v>..>.>.>v>..
v.v.v>v.v..vv.v..>.>v.v.v..>.>.>.>...v.v.>>v>vv.>>....>>..vv...v.v.>..v>.>v.v..v.>.>.>..>...>.vvv...v.v>....vv.>..v>.vv.....>..v>>>.>v.>..v
v...>.>.>v>.v....vv.v>...>v>vv.>..v...>>>..>.>........>..v.>>.v.....>.vvv...>v.>>.vv>v>>>>...>.vv.>...>.>..v..>>>...v.vv.>>v....>.vvv>>v.>.
.>...vv.v........v.v......v>vvv.vv..>...vvv..vv.>.v.v...>vv.>>...>.v..>v>vv>.>v...v.v..vvv.v>>...>.>.vv.>v>v>.v.....>.v.v.>.>v>....>v..>v.>
..v.vvvv.v....>.vvvv.....v.v...>>v>.>.>.vv>>vv.v.v.v.>.vv>vv.>.>v.vvv.>v..v>v.>...>.>>....>.v>...vv...>v>vv...vv>>vvvv..v.v.v>>.>v>..>v>>v.
..>...v.v.....v.v.v>..>..v.>>>..v>v....>v>v..v>.v....>vv>..>.>.....v..>>v..>>v>...>v>v..>.v.>>....>vv.>...vv.........>v>.v..>>v.v.v>>v.v>>>
vv>.v.v>vv.........v..>..>>>>v...>..v...v..v>..vvvv....v.v...v>..>>v.>.v.>v.v.v>..>....>...>v>>vv...>...>>>..vvvv..>.>>v.v>...v..>.v..v.v..
.>.>vvv..v.>.v>.........v...>..v.>....v.v>.v.v.v..>.>.v..v...v.......v...vv.v.v..v..v>..v..>>>.v.v>...>..>.>>>v>>..>>..>..v...>v....>.....>
v.v.vv.vv>..>>v.>>.>.>>v..>v.vv...>vv....>.>....v...v...>v...>..v>.v>v...>..vv>>..vvv>....>vv>vv>.....>v>>v.>>v..>.v...v..v>>..>.v..v..v...
vv...>v.>...vv>.>.v>..v.....v.>...>.>v.>vvv>>>.>>.........>.>..>...v>..vv..v.v.v.>vv.v>>...>>.v..v>v......>v>v.v...vv....>>>..>>v>.vv......
v>.v..v..>.v>>....>.>.>>v>.v.>v.v>.v.>v.v>..v>.>.v>v......>>.>......v..v.v.>.v>>v...>v>>..v....>.v..vv>...>.v..>....v.>.>......v.>.>v>v>..>
>>v>.>>..vv>.>>v.v.>v.v...vv.>>.>>..v...v>v....vv...>>>.v>..vvvv.vv>v>>...v....vv.>.>.v....v>...>vv...v.>.v.vvv.v>.vvv>>vvv>.......>.>.vv.v
...vv>v.v>..>.>.v...vvvv..vvv..>.v>..>.>v.>>>v....>..v>.vvv.>..v.>.>.v....>.......vvvv>.v>.>v.>>>.>vv..>.vv.>>...v..>>v.>>.>v..>vv.>v.>.>>.
>.>>v>>>.....>vvv>.vv.>v..>.>..v>>...>>v..>....>>>v..>.>v..>>v>v.>.>v.vv.v>vv..v>v>>>v.>...>...>>>.v>.v>>>v..vv>v>>>>>v>>.........>v.v>.>>>
.......vv....>v..>..v>v.>.v.v.v>>...v.v.v...v>v.>...v...v.v...>>>.v...>v.v>>.v.>....>>>..>.>v...v....>..>.v..>.v>.>..>>>.v>>.>v.>v>.>.v..>.
..v.v...vvv..>>>vv....>>..>.v>..>>...v.>>v..v...v..v.>>.>...v>..>.........v.>..>.vv.>.v..>.>v.>v>.v.v.vv.>...>v..>.v.v.v...v..>.vv...vv>.v>
v....>v.v>...>...>>.......v....vv>>....>....v...v>>.>v.>....>.>.vv>v.>>..>..>...v>v.v.>>>..>.>>..v>.>...>.v..........>..>>>.>v.v.>.v>.>>...
>>.>.....v...>.>>>vvv>.>>>.v>.v>v..>v..vv>..v>vv.>.v.>v.....>>>v.v.>v.>..>>v..>>..v.v..v.v.>>.v.>..v..>.....v...v>..>>>.v..v....v.....v.>..
....vv..vv.>..vv..>.>..v..v>.v.>v.>>.v...>.v..vv.>v.>>v...>...>..>v>.>...>vv.>.vv..v..>v>v>.v.>..>.>v>....v.>.v>..v...v>..v>>.>..vv.v>v.>.>
v.....>>.>v>v..v..>>v>v>>vvv.v..>....>.>>..vv.....>>..>.....vv>.......v>.>.v..>..v>.v.>.>.>...>.v..v.>>..v.v.vvvv>.v..vv>.>v..>v.v>>.vv...>
v>.v.>>...v.>..v.v>v.vv>..>...>v>>v.v>.v.>..v.>....>.>>v>.>>>vv.>..vvvv..>..>>>...>.....v>..v>>..v.v>..>>v....>.v.v..vv...>....>vv.>.vvvv>.
vv>v>>..>v>>.vvv..>v>vv..>>.vv.v>vv>.v..vv.v...>>....>.v.v>>.>>.>v...v.>...v>>>.v.vv>>v...v.>>..v..vv..v.....>>>.>>v.v>..>.vv>>..>.>.....>.
....vvv>..vv....v...v.v>v>>vvv>.v..vv.>>....>.>.v...>..>....v>...>..>v>vv..>..>>..v..>vv....vvv.>vvvv..v....>....>vv.vvvv.v..>vv.v.>v>.vvv>
>>>>v>v.....vv..>v.v>>.v.v.>..vv.v>>...>v.v..v.v...v>>.>v.v...>..>.>>..>.>v.>>vv.vv.v....v>.v..v....v.v..v.>>....v.>>>>.......>v....>vv.>v.
....v.v.>..v..>vv..v.>>>>.....vvv...v>>.v>..v.>.v>v..v.>v...v.>>>>.>..>..vv.v>.v>..>.>v.....v..>>..>.>v.v..v>v.>>.....>v.v>v.v.vvvv.>.v>>>>
>.>>.vv....>>.>..>........>.>.v...v.>.v......>.>..v.>..v..vv>.vv...vv...v.>v.>....>>......>>>.>vv>.v.>..>vvv...vv.....v>vvv.v...>.vvv.v.>>.
....v>...v...v.v...v...>...>.>v>v.>>...>...v>vv..vv.>.vv>...>v>..>>..>.>v..v>..>.>....v>..v...vv>.vv.>>.v>v.vvvv>.....v.v..>.v..vv>v>>v.>>v
v>..>>v>v.......v.......>v>.>.>.>.v.>>.v.>v>.vv.v.v.v>.v>.v...v.>>..v.....vv.vv...v.>.....>...>..>>>v..v.v>.v>v>v.>..v>v.>.>..v>...>..>v..v
.>..>>vv.>vv.v>v..v>>>....>>v.v..vv>>...>v....v>vvv>.....>.>.>..>v.>...vvv....v...vv..v.>...>...v.vvv..>>..>v.vv>.vvv>.>.>.v.>..>v.>vv..vv>
....>vv.>>>.v..>>v.>vvv...v..>v..vv...vvv.v.vv.v.....>.>vv..v>..>....vvv>..>>.>.....>>>..>v....>..v.>v.v>.>>.v...vv>.v>.v>.v>v....v...vv..v
>.v>....>>.>>...vv..v.>..>.v..>.v>..>.v.v.>v....v>>.v...>>v..>.>>vv..>v>>>.>..v>.>..>.vv.v....>.>.v...>.v.vv>v>v.vv..>.vv.v..vv...>.v..vv>>
..v.vvvv.>>>.......>>>...........v.>.>>>v>v.>....>vv.>.v>..v..>>.>.v.vv>...v...vvvv.>v>vv...>>>.v.v....v.>.>..v.>>>>..>..v..>>..>>.>>>.>>..
v>v>v....vv..v>v.>v..v.v..v..>.v.>>..>>v>....>...v.....>..>.vv.v.vv....>....vvv>.v.v.....>>v>...v.v>.>>>.vvv>>v.>>>.>v...v>.v..>......>>vvv
.>.v.>..>>..>..v..v>v>...vvv>v>>v>.>.>..v>>...>v....v.v...v>vv>>v.v.v.>v>>..>...vvv.....v>>....v...v.v>.v.>...v>.vv...>v......v>>.v>vvv.vvv
.v>.vv.>>..v.>.>...v>.v.>>.vv..>>>....>.>.>.vv..vv.....>v...v.>.>.....vv.v...>.v>v.vv>.>>v..v>>vvv>vv>>..v.v>>..>.>>>>v>...>v.v>.>v...vv...
>>vv>...v.v>..v..>vv..v>...>......>..v.>.v.v>v........v.>vv>v..v>.v.>.v.vv..v....v.>...v>.v>v.v>...>..v....>....>>>v>>vv...vv>vv.>..>.>....
.>.>>.>>.>.v>>...>.....>v..>.>vv.>.>v...vv..vvv....v.vv>v...v>.vv>.......v>.v.>....v>...vvv.>.v...v..>v.>>..v...v.>..v..>.>v...v>v>v>..>v>.
..v..v..v.vv>.v..v.....v.>...v>..>..v.>>>v>>v..>.>...>.v.>...>vv>.v..v...>v>v...>v>v.v>v>>v.>v..>..>vv..v>v.v.v.vvvv.>v>>>.>v>v.v...>v..>>>
..vvv>>..>v..v>>...v.>..v>>>>.....v.>>.........>....>.>..vv...v>..v.>......>.v>.v>..>..>>.vv.>>.>..v.>v...v>.>>>.v>.>.>.>v.>.....>>>vvvv>.v
v..v...vv...>>>>....v..>..v>..>.............>v..v.........vv.>.v>vv...v.v.>>v...>...>..vv....v...>..>..>...>v.....v.>v.>..>>.vv.......>>...
...>...>vv>>>.v>......v.>>>>>..>.>>..v>v>.>..v>>>v.>>......v.vv..vv.>>vv>v.v.>>>v>>.vvvv.>v...v..vvv>vv.....v...v>..vv...>...>>>..v.......v
v>.>>.>v.v>>..v>v....v>>>...v.v>..v..v>>.v..v.v.vvv.v>..>..v.vv...v.v....>..v.>vv>v>..>..>vvvv.>.v.......>v>>...>.>..v>v>.>>>v..>v>..>.....
..>.>.>>...>.v.>v..v..>...>..>v.>v.>..vv..v..>>..v.>>...>v...vv>>>>.>.v..v...>.v>.>v>...v.v.v>.vv......v..>v.....>.>.>.>.>>vv>>...>>.v.v.>.
v.>>>...vv>.>v>.>>v......>>>v.v..>.>.>v>>v>.v.vv.v>>.....>.>.vv.>>v>v......v>>v.v.>>..vv..v..>.v..>.>.>>>.vvv.>v..>..v...>.v.vv>>..v...v..>
vv.>.......v.v.....>.>.v.>>>vv..>v.v..>..v.v>vv.v>>..vv..vvv...>..>>.>.v..>.v>.>>v>.vv>.>v>vv.....v....>v>v>.v>.v..vv..v>.vv..v>...vvv..>.>
..v......v..v.>........v...>..v>v>.v....>..v>.>>v>.>>....>>>>.>.>v>..>.v>vv>>.v....>..>.>v>..v....v>>.>.vvvv.vv....>v.v>..vv.......>>.>.>.>
.>....v..>..vv....>.>....>vv>......v.>.vv...v>>....>>.v>.v>.>..>.>>..v..>....v.>>vvv..v.>>>>>.>>v..vv>v.v...vv.v.v>...>...v>.>vv.vv...v.>v.
>v>.>.>v>v>v......>.>>v....v.>.v.....v..>.v>v..>.v..>>.v>>v>.....>>>.>v....>vv.v.v>v..vv..v>vvvvv...>>>...>..>.v...>.>>..v>v..>vv.>..>.v...
v..>v.>..v..v>....v.>.>v..>....v>v.>.....>>vv.>>v...>v>.>v..vv.>>...v.>>..>v.>.>>.>>>>....v.>.vv>>v.....>.v....>.>..v>v..>.....>...>>.v....
>.v>.vv..>..v.>.....vv.vv.v>>...v>>v..>.v..v..>>v.>.vv...>.v.>..>>v..v..v....v>.>..>.v>v.>......vv..>...>.v>v.....>.>>>.v.v....>>>.>>.vv>>>
>..v>>...>.v..v.>..>v...v...v>..>.>v.v>.>.vvv.v..>.>..>>.>.>v.>vv....v>>.v>>.v>.v.v>v.v>..>.vv...vv.>.v......>>>v.>..>v..v....>v..>>...>.v>
...v>.>vv>..v>v>.vv>.>.>..v......>>v.>.>>.vv>v>.v.v.v.>>..>..>>.v.>.v.>.....v..>..v.>>..v>v>>.>.>.vv.v>vvvvvv.>v>.>>v..v.>.v.>.>>..v.>..vvv
v>..v.>v.......>.v.v>v>v.v.....v>.v>...>v>.>.>.v.vv..>v.>>..v>...v>.>.v>>.vv.v...v....vv.>..>.v>>...v..>>>.v>v....>v.>..>.v...v...>.>..v>..
v>vvvv>vvv.>>...>>.>.v..v....v.>v......>.v.>>.vv....>v>>>>..v......>vv>...>>>.v.v.v>>v..vvv>....>..>v.>v...v.v..>..vv..>>.v..v..>.>.v.>v.>.
......v.>....vv>>>.vv..>.>v>.v....>v..>..>.v.....vv>v....v>.v.vvvv.>.v...vv>.v.vv..>v.v.>>vvv...>vv.v>.v>.v..>.>.>.>>>..v.v>v>vv.vv>.......
>...>v..v..>vv>.v....>.v>.v.v.>..>v>.>..v.>.>v.>.>.v..v.v.>v>>v.>v.>....vv.v..v.>..>>...>...v>>..>....v.v>>v.v>v>.>.v..v.>..v.>>>...>......
....v>>v...v..>.v>.>.v..>>.>.>v..v>.>....v.v>..v>>vv>..vvvv>>...v....vv..>..v.vvv.>.vvvv>....v.>.>v...v...>....v..>.v>vv.v.vvv..v.v>.vvv>..
...v.vv.>v>>v>>.v>..v>.vvv>v>>...v>v>v>.v.>.v..v>.vv>v.v....>.>>vvv..vvv>.v.vv..>..>...>v.>.v.v....v....v>>...v..>.vv.vv.vv.>.>.vv..v.>.>vv
>....vvv>>..v.>.v.v>v.>.v>>>..>.>.vvv.>.>>vv>v.v.>..>...v.v>..v..v.v>v>........v.vv...v>v.>>..>.>...>v..vv>>.>>.>....>vvv>..>.>>....>..>v..
v>>.>>v.>>vvv...v.>.....>.vv...v>>v..v..v.v>>.>..>>v.>>.>.>vvvv..vvvv.>v....>>....vv..v.v>v.>.>..v.>v...vv.>>.>>v.>...vv...v...v.v.>.vv.>..
v..>>>v.>>...v>.>v>..v.v>.>..>>..vvv.v....v>v..>...v>>>.>.vv>v>v.v....vv.vv>>.........>........v.vv>.>v.vv.v.v..>vvvvvv...vv..>>>......v>..
v>.....vvv>.vv>vv.>vv>v...>>v..>..>vvv..vvv....vvvvvvv.>v.>>..>v>>>>...>..v>.v..........>v>...>v>>..v..>>v....vvv..>......vv..v.>>v........
v.....v>....>>v>.vv.>>v.vvv.v>>v>.>..v..>.v>.vv....>>>v>.>vvv>.v.>..>.>>.v.vv..>>.vv.>>.>.>>.>.vv>>..v.v.>.>........>vv>>v.>..>vv.>...vv.>v
>v..>v.....v.....v..v>.v>v.>..>v.v>>>..v.v.>.>.v....>...v.>>v>v>..>..v>>.v......v>.v.v>.v..>v>..>.....vv.>>..>v.vv.vv.....>>.v..>.....v..>.
.>.>>vv>...>>vv.>..>>.v.>v.>vv>.v>>...>..>....v>.v.v>vvv>.v.>>>..v.>.v...v..>......v...>.>>>v..>v.v.>..>.>>..vv.>v....vvv>.>.>>>>..>.vv...v
>......>...v>..>.v.v>.vvv.v>v>..>...>vv..vv>v>>>...vv.>.vv.v>vv..v.v>v.v>>>.>v.>>.>>.v..>.>.>.>..>.vv..vv.v.v.....>..>v..v.vvvv>v......>.>v
..v.v>v.>v.>v>vv>>.>..>..>v>>.vv...>....>v.v.v.vv.....>.>vv....>..v>.>.>.>.>..>>v>v...>....v.vv.>>.v>.>..>>.>v..vvv>....v.>.....v>.>...v..v
v...>v....v....>..v....>vv.>.v.v.vv.......vv.v...>vv>>..>...>.....v.v>.v.v>>.....>>.v.....v.>.vv.v>.>.v..vv...v....>>.v.vvv.v....>.....>>.>
...v.v>.>..>.>.>...vv....>....>v....>.>>vv..>v>v..>...>..v..v.>>>v>>vv...v..>>.>>..v.v.>>.>.v.>...>....v.>.>v.>...>>v....>>.>v.v......>>..v
..vv.v.....v>...>..v...vv.........>.....v..vv>....>vvvv..>v>v.>>>>v.v>..v.v.>..>...>v...>.>...>.>v>>...vv.v..v.>>.....>....v>v>v..>..vv....
..>v>>.>..v.....>v.v.v.v>.>.>v.v.>>>>vv>......>.v.v.>>.>.v>>..vv..v.>...>..v>v.>v>>vvv..v..vv.>.>...>>....v>v..v.......>v.vvvvv...>.>>..>..
v.v..>>v..>.>v..>..v.>...>v.....>vvv..>.>v.v....>.v.v>..>.v>.>.>vvv..>..v...>...v>v.....>v..v.v.>vv..>>...>.v>..v>>.v..v.v>..v>..vvv>..>.v.
.v.vvvvv.>.>>>>vvv>>v>>>....>vv..>..v>..v>>v...>..>v.vvv>....>.v.....>....>.v>.>vv.v>vv..>..>...vv>.v.>>..v.v.v>.>v>.>v>..v..>.>v...v>.v..>
.v.v>..>....>.v>vv..>.>>.....>.>..>v>..vvv.v.v>..vv.>.>>.>..v.>>.>............v.vvv>.v>>>..v..>...>.>v>>...v..v.v...>>v>.>..>>v.v>v..>.>v>.
v>>..v.>v.v.>.>>v......>v...>>...>>>..v...v...>.v...v>>v>>>>vv.>>..>...v....>>...>vv.>v...v.....vv.v.v..v.>...v.v.>....>.>..>v...>.>>.....v
>.v.>.v...v.....>v.vv....>v.>.v.v.v....>.........>v..>....v.vv.v>.v.>...vvv.v.>>>vv.....>.....vv.>>>.>>.v>..>..>.>v.....vvv>v>....v.>..>.>v
v>v.v.>...>.vv..>>.>>.>..v.>.>v.>.v..v>v.>.v.>..vv..>>v..>..v>.v.......v..v..v.>vv.>>v...>....v>..vv.>>..vv.v....v>...v.v....v>.>..v..vv.v.
..>.v.v.>v...>>v>.>.>.vv..>..>v.....v.>>vv..v.>.>..>>..>.vv..v.v..vv...>>.vv>v...>vv>>>v....>vv.v.....>>.vvv.v>>>v....vv.v..v..>.>.v..>..>>
v>..v>.>..>..>....>>v...v..v>..>..>v..>.v>...v...>.>.>.>...>...v.v>..v.>v>.>vv..>..vvv..v>vvv.>..v.v.v.>v..>>>>....v>>>>>v.v..v>>...v..v..v
.>....v>.>...v.v>.....>v....>......>>..v..v..>>vv.vv.v.v.v......>..>.vvv.>>..>v.v.>.>.....v>.>.>>>.>.vv.....v>v.>>v....vv.>.v.v.v....v...>.
v>v.....>.vvv.>....>.>>vv.>>vv>>>.v>>vv>..>..vv...>>>vv>>>..v..vv.>...vvvv>....>......v.v..v.v>..vvv..>.v>.v..>.v...v.vvvv>...v.v>.>>....>.
>>.>v..v.>.v.>...>>.>..>vv.....>v...v...>..>>..>v>..vv>..v.vv>.v.....v....>v..>v.v.>....>>vv>...>v>>..vvv>.......vv..>.v>v.vv>vvvv...>v..>>
..vv..>..vv.v>..v>>>>v....>>......>..v.v...v.v>vvv.>>>>vv..>v..>>..>.>.>v.v.>.>vvv>.v.v..vv...v.....v..vv.v....v.>.v.v.v>>v....v.....v.v>vv
..v.v.>>....v...v>.>.....v.v>....v...v..v..v>.>vv.>v.v>v.v..>>>.v>.>>v>..v>vv.>vv......>v.v.........v..v>v>.vvv.>v>v..>v.v..v.vv.vv>.v>>.>.
v...v.>v>.>..>v>..>>v.>.v>.v>.>.v....vv>..>..vv.>..>v..>v.vv.>.>..>>v..v>.>.....>....>>..vv.>>..>.>....>vv.v..v>.vv.vvv...>.>>......>>..v..
.v..>>...>>..>...>v.>....>>..>.v..>>..>.>..>v>.v>.v.v..>v.>>v>...v.>.v..>..>....>...>.>.>.v....>vv>>>.>v>.vv...>.v.v>v..>>vv..>.>v.v.v.>.v>
v..v...v..vv.>.>.vv...vv.v..>>vv.>..v.v>.>v..>>.>..>>...v..v.>>>.v>>...v.>v.v>>v..>..v>>>v.v..>..v.>vvv..v>>...v..>...>...>>..v..vvv>.>....
...vv.v.>.....>>>vv.....v.>..v..>v..>>v>..>.>.v>.v..>>v.vv>>v...vv..>vv.>.v..v>v....>>....v.>>v...>>.v.v>>v..v.v..v>>>>vv>>..>...>v.....v.>
>>.v..v.>.vv..v.>.v>.>.v>.v>>.>>v.>>..>..>.vvvv>>.v.>>..vv...>vv>.v.>...v>...>.v..>v>.v>v..>>>>.....v.>..v.vv.v.>....v.>.vvv.v>v>..>.>>v>.v
....>.v>>..v.vv...>.v...v>....>v>..v>.>>...>>..vvv.>.vv>>>>v.vv>..>..>vv.v>>..>.>>>>..vv>>.>.....>.v.v>...>.>>>..vv..v...>.>..>>v..v.....>>
>>>.v.v.>>.v..>v.v......>.v>..v>.>>..v>v...v...v>v>..v.>.v...>>v>.>..v...v>..>.>vv.>v.vvv>>.v>..........v.........>.v..>.>...v.....>..>..v.
>.>>>>vv.>>..>.v>...vv..vv>..v>.>>.vv>.>..v...v>...>>.....>v.vv...>>.v>>>.v...>.>v>v.vv.....>>.v>.v...v>>.....>..>>v..v>.v....>v...v.....>v
.v..>.v.v..>.v..v..v.>..v.v>v.v>>vv>vv...>..v.v.....>>..v.v>.v>>.>vv....>>>.>>vv>......v>>..v..>.>v>.>>>....v>vv..>.....>>vv.v..>..v...vv.v
..v.>.>.>v>.v>.>...>..vv..vvv....v.vv..v....>.>.v.v...>....>v>v....v.v..v>vv...v>>v.v....v.v.>..vv..vv.v>>>..v....>>.v>.>.>v...v.v>>>>.v...
v.v..>>.>vv.v>......>v>.>..v>.v.>...>......vv..vvv.v..>...v..v>.>.v>v...v..>....>.>.v.v..vv.>v.>v>.vv>v...v>.vv..v..v...>>.v.v....>>..>>vv.
.vv...vvvv.>.v...v.>.v.>v......>vvv>>v..v>vv.>>.v>v.vv..>.>..>......v>...v.>>>>>.vvv.>>v...>>>v..v.v>>v>...>.....>vv..v.>v>......>>>v...vv>
....>>...v>...>v>>>>v>>>.....>....>.>.>..>>..vv...vv...v.>vv.>>>...>>.>..v>>vv.v.>..vv..>.>v..v.>.v>..>.vv.>v>v>.>...v..v.v...v>.>v...v>>>.
.v.v.v.v>.......v.vv......v..v.vv>>>...>..v.>.>..>......>v..>v>v>vv.>.v.v.>.v.>..v>.v.>>>v..>>..>.v..>...vv>.>>v>.....v..v.>.>.....vvv>..>.
v.....vv>vv>.>vvv..>>...>>v.>v.vv...>....vv.v>>>vv>.>>v.v>>vv.vvv>.>>..>vv>.v...v...v...>...>.>>vv>>v...vvvvvv>..v..>.v..>>>..>.vvv...>vv>v
>..>>>.vvv..vv>>...v.v>...>...vv...>>v.v.>v....v>.....>v.v.>...>v>vv>>.>>.>.>..>v>..v.>>v.v.v.>...>>vv.>>.>.>..v>.v.v....vv..v>.>...v>v.>.>
>v>...v..vv...>.>.v.>>...v>>>.>v.v.v.v.>...vvv.>.v....v....>....v>v>.>vv.>v...v>...v.......>.v.......>v..v...v>.>..v>..>..v>.v..>vv.>v>vv..
vv.>>..v>>vv.v..v.vv>>>>>v>>......v..v...v>vv>>v.v..>.v>vv>v..v......>>>>v>v..>v>.v..v.>..v....vv..v...v>>>..>....>...v...>>>.vv>..>v....>>
..>.v.v.>>.vv...>v>>>v>>.v..>>.>>>.....>>.vv>v>>>>...v...v...v.>>..>>..>>v.>>>>v...>.>v..>.>.>..>.v.>..>v>v.v.vvv>....vvv.v..v.v...v.v>v...
>v.>>>.v.>v.v.>.>v>.v>.>>>vvv.>.v>..>vvv..v..>.>.vv>v.>..vv..v...v.>>v.v>..>.>vv.v.vvv.v...vv>v.vv..>v.v>..vv...>>.......v....>>...>vv..vv>
vv>.>v>.v.vv..>.>.>..>>vv>>v>......v>.v.v>.v.v.....>.>>..>v>v.>>.>..>v.v>v.v>...vv>v>...>>vv..>.>.>>.>>.v.v...vv....>v.v..v>v.>>..v>>..v.>.
.>v>.v.>>...v....>...v..>v>v.>...v.>.....v.>.>.>v......v>>.>v.>.v..>.>>...v..vv..>v..v.>..vv>>..>.>.v..vv.>.>.....>....>.vv.v...v.>v.>v..v>
>v>.>vv..>.>>v>..>v>v.>...>.v.vv>>.>.vvv..>...>....v>.>vv>>..>>>.v>>v>.v..>..v..v>...v.>v...>>..v>>..>.v.>>..v..vv..vv.....v.v..v..vvv....v
vv....>vvv.>.>>>....>.>v>.>vv..v>.>..>.>v>.vv.v.vv.>v>.>>.>>vv>>.....v....>>>vv>>....>vv.v..>.v.vv>..>v....>.>>>>..>.>..vvvv.v.......v...v.
>>..>.>.>vvvv>.>v>>v.v.>>>.v>..>.>.....v>.....vv.>...>>v.>v.>>...>>.>.vvvv>v.....v>v.v>>..v..>..>>.v.>.>...v>...vv>.>v>..vvv......v.>v....>
.vvv...vv.>.>.v..vv>>.>...v>.vv....vv.v..v>........>v.>>>...>.>.....v..>.v.>v.v..>..v..v>.>..>>>vv>..>.v...v>...vvv.v.v.>.v.vv..>>>v..v.>v.
>v.v>>>....vv>v..v..vv>.v.>.....vv.>..v..v>vvv.>>v.v.>.>.>v.>..v>v.v>.v.v...v..v.>.v.>v.>v>.v>v.........v..>v.>v>v.v.v.>..>.>....vvvvvv>.>.
...vv.>v.vv.>v>..v..v.>v>v..>.....>.>>.v.>>.>..>>.v.vv..>v.v>v..>v...v.vv.>.>.v>vv...vv.vv.v.vvv...>v>vvv......v...>>>>.>.v>..vv..>.v>>>..>
>.v...v....v.vv.....>>v..>....vv..vv....>..>>..>.>vvvvv>v..>.>>>>>..>v..v.>>>.v>....v..v>...>...vvvvv...>>.......>>vvvv.>v..v...>..>>>.....
.v.>v..>vv...v>......>vv..v.....v....>.vv.>vvvv.>v>v.>.>v..v......v.>>.>....v.>>v>>v.>v>>v....>.v>.v>...v>.v>v>.>..v>...>>>v>..>>>>>...v.v>
.>>.v>.>.>>>..v.v.v.v>>v..v>.>>v..v>v>>.>>......>v>..>.>vvv.>...>>...>.>>.>>..>>v.....v..>......>...v>vv..v>..v>.vvv.vvv....>.>..vv>>..v>v.
v.>.....v>>vv.v.v>>vvvv.>>vvv...>v>.v.v...>..>>v.>v>.>v>>>....>v..v..v>..>..vv>>.v.v.vv.v..v....v>.v.v.vv...v...>.>.>v....v.>>v..vv.>>.>...
>v>vv.>v...>.v..v.vvv>.>.>>vv>..>>>...>v.>v..vv>vv..v.>>v.>v>v.>..>...v..v>>>vv..>>v...>.v.>.v.>.v>.v.>.>v...v>>>v..vv..v>.v>.vvvv>v.>.v.>.
.>..v..>.vv.>vv.>v.>......>..v....v>.v>vv>...>vv....v...>v>.v..vv>>.......v>v.>v>>....v.>....vv.vv..>.>>v.v...>.>v.>.v.vv.>.>v...v..>>.v...
>.....vv...>v.>v>.>>.vv>>>..vvv.>vvv>..>v..v..v>v>>vvv>v>>..>>v..>..v.v.>v..>...v>.>v....v.v>>..v....v.vvvv...>....v.>..v.>v....v.>.>vv...>
>v..>>.v>>.vv>..>v.>..>>v>v..>..v...>>v.v.>v............>vv.v.vv..>>vv...>..>>.>...v.v>>..>>v..v>.vv..v.v>v..>.vv>>.>>>v>.v>>.>v.vv>..v.v.>
.v..vv....v..v.v.v.........v>>.>v...>v..v>.v.>..vv>...v...v.vv.v>v..>..vv.vv..>vv.v.>.v>vv.>..........>>vv...>v>.....vv..v.>.>v.v>...>....v
.>>.>...v.>v....>.....v>.>v.>.....v.>>..v...>.>v.>>.>>>.vv..>>.>v..v>.>>...>..>.vv.v....>.v..>vv.v...>>.v>.vvv.>.>v.vv..v.>.>>>>.>>...v>v..
...vv>>>v..>..v>vv.>.>>v..v>vvv>..vv.>v>.v..vvvvv.....vv>>.v>v..>..>>.v.v...v...v...>v.v..vv.v.>v>.>v..>v.>.vvv..>.>.v..>.vv..>v>...>>v.>..
v.vv.>>>..v>.vv>...v>....>v>..>v.>.....>vv..>>......>>.>.vv.v..>>..>.>.v.....vv..v.v.....>.v>v.>.>>.>.v>>>.v.>..v..vv..>.v...>..v.>.>>..v.v
..vv...v.>v>.........v>>v.....v..vv.>vv.>.>.>...>>.......>...vv.>vv>.....v.>>.>......>....>>.vv..>....vv.v.vv..v..v....>...v.......>v>..>.>
.>.v..v.....>.>>.v.>>...v.>.v>.v>..v....>>v>>v>.>..>.v.vv.v.>..v>>...vv.v.>>>...v.>>.v>vv.v.vv...>v.>>....v.v....vv>.v.v...>...>...>v.>v...
.v.vv>>v.v.vv>..>.>.>.v.v.>.....vv>>v>vvv.....>>>v.>.v..>>..>.vv>v..v.>vv.>v.>..v.>vv>v>...v>v>>.v.>.....>..v>.>..v>v..........vv......>.vv
.vv..>>>>..v.>.v.>..>.v>.....v.>>v.>.......vv>>v.v>..>>.>v>>>.....>..v......>..v>.vv.>.v.>v>.>.v....>v.>v.v.v..v.vv...v.vv>.v>.....>..v>..v
.v..v>v>>....v....vv>...vv..v>...v..>...>...>..>v..>>>.vv.v....v...>v.>.......v.v.>v....v..v>...........v..>v>>.>.>>v....v.>.v...v.>.v>..v.
""".compactMap { Space(rawValue: $0) }

