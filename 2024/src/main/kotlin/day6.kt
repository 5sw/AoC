fun main() {
    val grid = CharGrid.read("day6.txt")

    var position = grid.find('^') ?: error("Guard not found")
    var direction = Direction.North
    val visitedPositions = mutableSetOf<Grid.Coordinate>()

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