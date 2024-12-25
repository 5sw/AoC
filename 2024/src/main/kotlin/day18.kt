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


    val input = readInput("day18.txt")
        .map {
            val (a, b) = it.split(',', limit = 2)
            Grid.Coordinate(a.toInt(), b.toInt())
        }

    val mem = CharGrid(size, size, '.')
    for (location in input) {
        mem[location] = '#'

        val isStopped = dijkstra(start, goal = { it == goal }, neighbors = { pos ->
            Direction.entries.asSequence()
                .map { pos.step(it) }
                .filter { it in mem && mem[it] == '.' }
                .map { it to 1 }
        }) == null

        if (isStopped) {
            println("Part 2: ${location.x},${location.y}")
            break
        }
    }
}