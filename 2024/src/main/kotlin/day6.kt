enum class Direction {
    North,
    East,
    South,
    West;

    fun turnClockwise() = when(this) {
        North -> East
        East -> South
        South -> West
        West -> North
    }
}

fun CharGrid.Coordinate.step(direction: Direction) =
    when (direction) {
        Direction.North -> copy(y = y - 1)
        Direction.East -> copy(x = x + 1)
        Direction.South -> copy(y = y + 1)
        Direction.West -> copy(x = x - 1)
    }

fun main() {
    val grid = CharGrid.read("day6.txt")

    var position = grid.find('^') ?: error("Guard not found")
    var direction = Direction.North
    val visitedPositions = mutableSetOf<CharGrid.Coordinate>()

    while (true) {
        visitedPositions.add(position)

        val next = position.step(direction)
        if (!grid.inside(next)) break

        if (grid[next] == '#') {
            direction = direction.turnClockwise()
        } else {
            position = next
        }
    }

    println("Part 1: ${visitedPositions.count()}")
}