fun main() {
    val iterator = readInput("day15.txt").iterator()
    val input = Sequence { iterator }

    val grid = CharGrid(input.takeWhile { it.isNotEmpty() }.toList())
    var robot = grid.find('@')!!

    val program = input.flatMap { line ->
        line.map {
            when (it) {
                '^' -> Direction.North
                '>' -> Direction.East
                'v' -> Direction.South
                '<' -> Direction.West
                else -> error("Invalid direction $it")
            }
        }
    }

    grid[robot] = '.'
    for (direction in program) {
        val next = robot.step(direction)
        if (grid.push(next, direction)) {
            robot = next
        }
    }

    val part1 = grid.coordinates()
        .filter { grid[it] == 'O' }
        .fold(0) { acc, coord ->
            acc + coord.x + 100 * coord.y
        }

    println("Part 1: $part1")
}

fun CharGrid.push(position: Grid.Coordinate, direction: Direction): Boolean {
    if (this[position] == '.') {
        return true
    }

    var next = position
    while (this[next] == 'O') {
        next = next.step(direction)
    }

    if (this[next] == '#') {
        return false
    }

    this[next] = 'O'
    this[position] = '.'

    return true
}
