fun main() {
    val maze = CharGrid.read("day20-sample.txt")
    val start = maze.find('S') ?: error("No start position")
    val end = maze.find('E') ?: error("No end position")

    val paths = maze.findPaths(start, end)

    val total = paths.first { !it.cheated }.time
    println("Time without cheating: $total")
    val part1 = paths.count { it.time <= total - 100 }
    println("Part 1: $part1")

    paths.sortedBy { it.time }
        .groupBy { it.time }
        .forEach { (time, list) ->
            val saving = total - time
            println("${list.count()} x $saving")
        }
}

data class MazeResult(val time: Int, val cheated: Boolean)

fun CharGrid.findPaths(
    position: Grid.Coordinate,
    goal: Grid.Coordinate,
    visited: Set<Grid.Coordinate> = emptySet(),
    time: Int = 0,
    cheated: Boolean = false
): List<MazeResult> {
    if (position == goal) {
        return listOf(MazeResult(time, cheated))
    }

    val newVisited = visited + position

    fun canVisit(position: Grid.Coordinate): Boolean =
        position in this && position !in newVisited && this[position] != '#'

    val paths = position.neighbors()
        .filter { canVisit(it) }
        .fold(mutableListOf<MazeResult>()) { list, next ->
            list.addAll(findPaths(next, goal, newVisited, time + 1, cheated))
            list
        }

    return if (cheated) {
        paths
    } else {
        position.neighbors()
            .filter { it in this && this[it] == '#' }
            .flatMap { it.neighbors() }
            .filter { canVisit(it) }
            .fold(paths) { list, next ->
                list.addAll(findPaths(next, goal, newVisited, time + 2, true))
                list
            }
    }
}
