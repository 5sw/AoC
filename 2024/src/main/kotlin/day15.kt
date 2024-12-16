fun main() {
    val iterator = readInput("day15-sample.txt").iterator()
    val input = Sequence { iterator }

    val grid = CharGrid(input.takeWhile { it.isNotEmpty() }.toList())

    val grid2 = CharGrid(grid.rows.map {
        it.map {
            when (it) {
                '@' -> "@."
                'O' -> "[]"
                else -> "$it$it"
            }
        }.joinToString(separator = "")
    })


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
    }.toList()

    var robot = grid.find('@')!!
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

    robot = grid2.find('@')!!
    grid2[robot] = '.'
    for (direction in program) {
        val next = robot.step(direction)
        if (grid2.pushWide(next, direction)) {
            robot = next
        }
    }

    val part2 = grid2.coordinates()
        .filter { grid2[it] == '[' }
        .fold(0) { acc, coord ->
            acc + coord.x + 100 * coord.y
        }

    println(grid2.rows.joinToString(separator = "\n"))

    println("Part 2: $part2")
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

fun CharGrid.pushWide(position: Grid.Coordinate, direction: Direction): Boolean {
    if (!canPushWide(position, direction)) return false

    doPushWide(position, direction)

    return true
}

fun CharGrid.doPushWide(position: Grid.Coordinate, direction: Direction, fill: Char = '.') {
    if (this[position] != '[' && this[position] != ']') return

    when (direction) {
        Direction.East, Direction.West -> {
            val next = position.step(direction)
            doPushWide(next, direction, this[position])
            this[position] = fill
        }

        Direction.South, Direction.North -> {
            val boxStart = if (this[position] == '[') position else position.step(Direction.West)
            val boxEnd = boxStart.step(Direction.East)

            val nextStart = boxStart.step(direction)
            val nextEnd = boxStart.step(direction)

            doPushWide(nextStart, direction, this[boxStart])
            doPushWide(nextEnd, direction, this[boxEnd])

            this[boxStart] = fill
            this[boxEnd] = fill
        }
    }
}

fun CharGrid.canPushWide(position: Grid.Coordinate, direction: Direction): Boolean {
    val boxStart = when (this[position]) {
        '.' -> return true
        '[' -> position
        ']' -> {
            val start = position.copy(x = position.x - 1)
            require(this[start] == '[')
            start
        }

        else -> return false
    }

    val boxEnd = boxStart.step(Direction.East)

    return when (direction) {
        Direction.East -> canPushWide(boxEnd.step(Direction.East), direction)
        Direction.West -> canPushWide(boxStart.step(Direction.West), direction)
        Direction.North, Direction.South -> canPushWide(boxStart.step(direction), direction) &&
                canPushWide(boxEnd.step(direction), direction)
    }
}