import Foundation

let input = loadData(day: 17).lines()

struct Coordinate: Hashable {
    var x, y, z, w: Int
}



struct Cube {
    var cube: [Coordinate: Bool] = [:]
    var minX = 0
    var maxX = 0
    var minY = 0
    var maxY = 0
    var minZ = 0
    var maxZ = 0
    var minW = 0
    var maxW = 0

    func neighbors(_ c: Coordinate) -> Int {
        var count = 0
        for xOffset in -1...1 {
            for yOffset in -1...1 {
                for zOffset in -1...1 {
                    for wOffset in -1 ... 1 {
                        guard !(xOffset == 0 && yOffset == 0 && zOffset == 0 && wOffset == 0) else { continue }
                        let current = Coordinate(x: c.x + xOffset, y: c.y + yOffset, z: c.z + zOffset, w: c.w + wOffset)
                        if let value = cube[current], value {
                            count += 1
                        }
                    }
                }
            }
        }
        return count
    }

    subscript(_ x: Int, _ y : Int, _ z : Int, _ w : Int ) -> Bool {
        get {
            cube[Coordinate(x: x, y: y, z: z, w: w)] ?? false
        }

        set {
            cube[Coordinate(x: x, y: y, z: z, w: w)] = newValue
            if newValue {
                minX = min(x, minX)
                minY = min(y, minY)
                minZ = min(z, minZ)
                maxX = max(x, maxX)
                maxY = max(y, maxY)
                maxZ = max(z, maxZ)
                minW = min(w, minW)
                maxW = max(w, maxW)
            }
        }
    }

}

var cube = Cube()

func cycle() -> Cube {
    var result = cube

    for x in cube.minX - 1 ... cube.maxX + 1 {
        for y in cube.minY - 1 ... cube.maxY + 1 {
            for z in cube.minZ - 1 ... cube.maxZ + 1 {
                for w in cube.minW - 1 ... cube.maxW + 1 {
                    let n = cube.neighbors(Coordinate(x: x, y: y, z: z, w: w))
                    if cube[x, y, z, w] {
                        if n < 2 || n > 3 {
                            result[x, y, z, w] = false
                        }
                    } else {
                        if n == 3 {
                            result[x, y, z, w] = true
                        }
                    }
                }
            }
        }
    }

    return result
}


for (y, line) in input.enumerated() {
    for (x, char) in line.enumerated() {
        cube[x, y, 0, 0] = char == "#"
    }
}

for _ in 0..<6 {
    cube = cycle()
}

print(cube.cube.values.reduce(0, { $0 + ($1 ? 1 : 0) }))
