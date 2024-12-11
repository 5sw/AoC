fun main() {
    val map = CharGrid.read("day10.txt").map { it.digitToInt() }

    val part1 = map.findCoordinatesOf(0)
        .fold(0) { acc, start ->
            acc + map.pathsToTop(start).size
        }

    println("Part 1: $part1")

    val part2 = map.findCoordinatesOf(0)
        .fold(0) { acc, start ->
            acc + map.pathRating(start)
        }

    println("Part 2: $part2")
}

fun <T> Grid<T>.findCoordinatesOf(value: T) = sequence {
    for (y in 0..<height) {
        for (x in 0..<width) {
            if (get(x, y) == value) {
                yield(Grid.Coordinate(x, y))
            }
        }
    }
}

fun Grid<Int>.pathsToTop(coordinate: Grid.Coordinate): Set<Grid.Coordinate> {
    val height = get(coordinate)

    if (height == 9) {
        return setOf(coordinate)
    }

    return Direction.entries
        .map { coordinate.step(it) }
        .filter { it in this && this[it] == height + 1 }
        .fold(emptySet()) { acc, next ->
            acc + pathsToTop(next)
        }
}

fun Grid<Int>.pathRating(coordinate: Grid.Coordinate): Int {
    val height = get(coordinate)

    if (height == 9) {
        return 1
    }

    return Direction.entries
        .map { coordinate.step(it) }
        .filter { it in this && this[it] == height + 1 }
        .fold(0) { acc, next ->
            acc + pathRating(next)
        }
}