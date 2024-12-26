import kotlin.math.abs

fun main() {
    val maze = CharGrid.read("day20.txt")
    val start = maze.find('S') ?: error("No start position")
    val end = maze.find('E') ?: error("No end position")

    val shortest = maze.findShortestPath(start, end) ?: error("No shortest path found")
    val total = shortest.last().second
    val toGoal = shortest.associate { (step, fromStart) ->
        step to total - fromStart
    }
    println("Time without cheating: $total")

    val part1 = countShorterPaths(shortest, maze, toGoal, total, 2)
    println("Part 1: $part1")

    val part2 = countShorterPaths(shortest, maze, toGoal, total, 20)
    println("Part 2: $part2")
}

private fun countShorterPaths(
    directPath: List<Pair<Grid.Coordinate, Int>>,
    maze: CharGrid,
    toGoal: Map<Grid.Coordinate, Int>,
    total: Int,
    shortcutLength: Int
) = directPath
    .flatMap { (step, fromStart) ->
        maze.circle(step, shortcutLength)
            .filter { it != step && maze[it] != '#' }
            .mapNotNull { point -> toGoal[point]?.let { point to it } }
            .map { (point, distance) -> fromStart + manhattenDistance(step, point) + distance }
    }
    .count { it <= total - 100 }

fun <T> Grid<T>.circle(start: Grid.Coordinate, distance: Int) = sequence {
    val xRange = (start.x - distance).coerceAtLeast(0)..(start.x + distance).coerceAtMost(width - 1)
    val yRange = (start.y - distance).coerceAtLeast(0)..(start.y + distance).coerceAtMost(height - 1)

    for (x in xRange) {
        for (y in yRange) {
            val point = Grid.Coordinate(x, y)
            if (manhattenDistance(start, point) <= distance) {
                yield(point)
            }
        }
    }
}

fun manhattenDistance(from: Grid.Coordinate, to: Grid.Coordinate) = abs(from.x - to.x) + abs(from.y - to.y)

fun CharGrid.findShortestPath(start: Grid.Coordinate, end: Grid.Coordinate) =
    dijkstraPath(
        start,
        goal = { it == end },
        neighbors = { position ->
            position.neighbors()
                .filter { it in this && this[it] != '#' }
                .map { it to 1 }
        }
    )?.steps
