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

    val part1 = shortest.flatMap { (step, fromStart) ->
        step.neighbors()
            .filter { it in maze && maze[it] == '#' }
            .flatMap { it.neighbors() }
            .filter { it != step && it in maze && maze[it] != '#' }
            .mapNotNull { toGoal[it] }
            .map { fromStart + 2 + it }
    }.count { it <= total - 100 }
    println("Part 1: $part1")
}

fun CharGrid.findShortestPath(start: Grid.Coordinate, end: Grid.Coordinate) =
    dijkstraPath(start, goal = { it == end }, neighbors = { position ->
        position.neighbors()
            .filter { it in this && this[it] != '#' }
            .map { it to 1 }
    })?.steps
