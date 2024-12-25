import java.util.*

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
            if (neighbor in visited) continue

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