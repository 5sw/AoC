fun main() {
    val size = 71

    val memory = readInput("day18.txt")
        .map {
            val (a, b) = it.split(',', limit = 2)
            Grid.Coordinate(a.toInt(), b.toInt())
        }
        .take(1024)
        .fold(CharGrid(size, size, '.')) { acc, coordinate ->
            acc[coordinate] = '#'
            acc
        }

    val start = Grid.Coordinate(0, 0)
    val goal = Grid.Coordinate(size - 1, size - 1)

    val distance = dijkstra(start, goal = { it == goal }, neighbors = { pos ->
        Direction.entries.asSequence()
            .map { pos.step(it) }
            .filter { it in memory && memory[it] == '.' }
            .map { it to 1 }
    })
    println("Part 1: $distance")
}