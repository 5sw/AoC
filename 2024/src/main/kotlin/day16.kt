import java.util.PriorityQueue

data class Position(val coordinate: Grid.Coordinate, val direction: Direction)

fun main() {
    val grid = CharGrid.read("day16.txt")
    val start = grid.find('S')!!
    val goal = grid.find('E')!!

    val startPosition = Position(start, Direction.East)

    val part1 = dijkstra(startPosition, goal = { it.coordinate == goal }) { current ->
        Direction.entries
            .asSequence()
            .map { Position(current.coordinate.step(it), it) }
            .filter { grid[it.coordinate] != '#' }
            .map { it to 1 + current.direction.turns(it.direction) * 1000 }
    }
    println("Part 1: $part1")
}

fun Direction.turns(to: Direction): Int = when {
    this == to -> 0
    this == Direction.North && (to == Direction.East || to == Direction.West) -> 1
    this == Direction.North && to == Direction.South -> 2
    this == Direction.East && (to == Direction.North || to == Direction.South) -> 1
    this == Direction.East && to == Direction.West -> 2
    this == Direction.South && (to == Direction.West || to == Direction.East) -> 1
    this == Direction.South && to == Direction.North -> 2
    this == Direction.West && (to == Direction.North || to == Direction.South) -> 1
    this == Direction.West && to == Direction.East -> 2
    else -> error("Missing directions")
}

fun <T> dijkstra(start: T, goal: (T) -> Boolean, neighbors: (T) -> Sequence<Pair<T, Int>>): Int? {
    val distanceFromStart = mutableMapOf(start to 0)
    val visited = mutableSetOf<T>()
    val queue = PriorityQueue<Pair<T, Int>> { a, b -> a.second.compareTo(b.second) }

    queue.add(start to 0)

    while (true) {
        val (current, totalDistance) = queue.poll() ?: break
        if (goal(current)) {
            return totalDistance
        }

        visited.add(start)

        for ((neighbor, distance) in neighbors(current)) {
            if (neighbor in visited) continue;

            val newDistance = totalDistance + distance

            val currentDistance = distanceFromStart[neighbor]
            if (currentDistance == null || newDistance < currentDistance) {
                distanceFromStart[neighbor] = newDistance
                queue.add(neighbor to newDistance)
            }
        }
    }

    return null
}