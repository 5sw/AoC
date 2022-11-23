struct Moon: Hashable {
    var x: Int
    var y: Int
    var z: Int

    var vx = 0
    var vy = 0
    var vz = 0

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    mutating func move() {
        x += vx
        y += vy
        z += vz
    }

    mutating func applyGravity(from other: Moon) {
        vx += grav(x, other.x)
        vy += grav(y, other.y)
        vz += grav(z, other.z)
    }

    var energy: Int {
        let pot = abs(x) + abs(y) + abs(z)
        let kin = abs(vx) + abs(vy) + abs(vz)
        return pot * kin
    }
}

func grav(_ a: Int, _ b: Int) -> Int
{
    if a < b {
        return 1
    } else if a == b {
        return 0
    } else {
        return -1
    }
}


var moons = [
    Moon(x: -13, y: 14, z: -7),
    Moon(x: -18, y: 9, z: 0),
    Moon(x: 0, y: -3, z: -3),
    Moon(x: -15, y: 3, z: -13)
]

@discardableResult
func step() -> Int {
    for a in 0..<moons.count {
        for b in 0..<moons.count where a != b {
            moons[a].applyGravity(from: moons[b])
        }
    }

    var energy = 0
    for i in 0..<moons.count {
        moons[i].move()
        energy += moons[i].energy
    }
    return energy
}

var seen: Set<[Moon]> = []

var steps = 0

repeat {
    seen.insert(moons)
    step()
    steps += 1
} while !seen.contains(moons)

