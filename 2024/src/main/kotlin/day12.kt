fun main() {
    var part1 = 0
    var part2 = 0

    while (all.isNotEmpty()) {
        val start = all.elementAt(0)
        val (area, fenceLength, fenceSides) = input.floodFill(start)
        part1 += area * fenceLength
        part2 += area * fenceSides
    }

    println("Part 1: $part1")
    println("Part 2: $part2")
}

val input = CharGrid.read("day12.txt")
val all = sequence {
    for (y in 0..<input.height) {
        for (x in 0..<input.width) {
            yield(Grid.Coordinate(x, y))
        }
    }
}.toMutableSet()

fun CharGrid.floodFill(start: Grid.Coordinate): Triple<Int, Int, Int> {
    val visited = mutableSetOf<Grid.Coordinate>()
    val fence = Fence()

    floodFill(start, this[start], visited, fence)

    all.removeAll(visited)

    return Triple(visited.count(), fence.length, fence.sides)
}

class Fence {
    val horizontalSides = mutableMapOf<Int, SideList>()
    val verticalSides = mutableMapOf<Int, SideList>()
    val length
        get() = horizontalSides.values.sumOf { it.length } +
                verticalSides.values.sumOf { it.length }

    val sides
        get() = horizontalSides.values.sumOf { it.count } +
                verticalSides.values.sumOf { it.count }

    fun add(coordinate: Grid.Coordinate, horizontal: Boolean, first: Boolean) {
        if (horizontal) {
            horizontalSides.getOrPut(coordinate.y) { SideList() }.add(coordinate.x, first)
        } else {
            verticalSides.getOrPut(coordinate.x) { SideList() }.add(coordinate.y, first)
        }
    }

    data class Side(val first: Boolean, val start: Int, val end: Int = start) {
        init {
            require(start <= end)
        }

        val length get() = end - start + 1
    }

    class SideList {
        val sidesByPosition = mutableMapOf<Int, Side>()
        val sides: Set<Side> get() = sidesByPosition.values.toSet()
        val count: Int get() = sides.count()
        val length: Int get() = sides.sumOf { it.length }

        fun add(position: Int, first: Boolean) {
            if (sidesByPosition.containsKey(position)) return

            val before = sidesByPosition[position - 1]?.takeIf { it.first == first }
            val after = sidesByPosition[position + 1]?.takeIf { it.first == first }

            val newSide = when {
                before != null && after != null -> Side(first, before.start, after.end)
                before != null -> Side(first, before.start, position)
                after != null -> Side(first, position, after.end)
                else -> Side(first, position)
            }

            assert(before == null || newSide.start == before.start)
            assert(after == null || newSide.end == after.end)
            assert(position in newSide.start..newSide.end)

            for (pos in newSide.start..newSide.end) {
                sidesByPosition[pos] = newSide
            }

            assert(sidesByPosition[position] === newSide)
        }
    }

}

fun CharGrid.floodFill(start: Grid.Coordinate, type: Char, visited: MutableSet<Grid.Coordinate>, fence: Fence) {
    visited.add(start)

    for (direction in Direction.entries) {
        val neighbor = start.step(direction)

        if (inside(neighbor) && this[neighbor] == type && !visited.contains(neighbor)) {
            floodFill(neighbor, type, visited, fence)
        }

        if (!inside(neighbor) || this[neighbor] != type) {
            val first = direction == Direction.North || direction == Direction.West
            val fencePosition = if (first) neighbor else start
            fence.add(fencePosition, direction == Direction.North || direction == Direction.South, first)
        }
    }
}
