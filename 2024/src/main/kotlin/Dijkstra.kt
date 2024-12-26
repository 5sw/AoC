import java.util.*

data class PathResult<T>(val steps: List<Pair<T, Int>>, val totalDistance: Int)

fun <T> dijkstraPath(start: T, goal: (T) -> Boolean, neighbors: (T) -> Sequence<Pair<T, Int>>): PathResult<T>? {
    val distanceFromStart = mutableMapOf(start to 0)
    val previous = mutableMapOf<T, T>()
    val visited = mutableSetOf<T>()
    val queue = PriorityQueue<Pair<T, Int>> { a, b -> a.second.compareTo(b.second) }

    queue.add(start to 0)

    while (true) {
        val (current, totalDistance) = queue.poll() ?: break
        if (goal(current)) {
            val path = generateSequence(current) { previous[it] }
                .map { it to (distanceFromStart[it] ?: 0) }
                .toList()
                .reversed()

            return PathResult(
                path,
                totalDistance
            )
        }

        visited.add(start)

        for ((neighbor, distance) in neighbors(current)) {
            if (neighbor in visited) continue

            val newDistance = totalDistance + distance

            val currentDistance = distanceFromStart[neighbor]
            if (currentDistance == null || newDistance < currentDistance) {
                distanceFromStart[neighbor] = newDistance
                previous[neighbor] = current
                queue.add(neighbor to newDistance)
            }
        }
    }

    return null
}

fun <T> dijkstra(start: T, goal: (T) -> Boolean, neighbors: (T) -> Sequence<Pair<T, Int>>): Int? {
    return dijkstraPath(start, goal, neighbors)?.totalDistance
}