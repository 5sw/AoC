fun main() {

    var part1 = 0
    var part2 = 0
    while (all.isNotEmpty()) {
        val start = all.elementAt(0)
        val (area, fenceLength, fenceSides) = input.floodFill(start)
        part1 += area * fenceLength
        part2 += area * fenceSides

        println("$area x $fenceSides")
    }

    println("Part 1: $part1")
    println("Part 2: $part2")
}

val input = CharGrid.read("day12-sample.txt")
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

    println(fence.horizontalSides.flatMap { it.value.sides.values.toSet().map { side -> it.key to side} })
    println(fence.verticalSides.flatMap { it.value.sides.values.toSet().map { side -> it.key to side} })

    return Triple(visited.count(), fence.length, fence.sides)
}

class Fence {
    var length = 0
    val sides
        get() = horizontalSides.values.fold(0) { acc, sides -> acc + sides.count } +
                verticalSides.values.fold(0) { acc, sides -> acc + sides.count }

    fun add(coordinate: Grid.Coordinate, horizontal: Boolean) {
        length += 1

        if (horizontal) {
            horizontalSides.getOrPut(coordinate.y) { SideList() }.add(coordinate.x)
        } else {
            verticalSides.getOrPut(coordinate.x) { SideList() }.add(coordinate.y)
        }
    }


    val horizontalSides = mutableMapOf<Int, SideList>()
    val verticalSides = mutableMapOf<Int, SideList>()

    data class Side(val start: Int, val end: Int = start) {
        init {
            require(start <= end)
        }

        val length get() = end - start + 1
    }

    class SideList {
        val sides = mutableMapOf<Int, Side>()
        val count: Int get() = sides.values.toSet().count()

        fun add(position: Int) {
            if (sides.containsKey(position)) return

            val before = sides[position - 1]
            val after = sides[position + 1]

            val newSide = when {
                before != null && after != null -> Side(before.start, after.end)
                before != null -> Side(before.start, position)
                after != null -> Side(position, after.end)
                else -> Side(position)
            }

            assert(before == null || newSide.start == before.start)
            assert(after == null ||newSide.end == after.end)
            assert(position in newSide.start..newSide.end)

            for (pos in newSide.start..newSide.end) {
                sides[pos] = newSide
            }

            assert(sides[position] === newSide)
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
            fence.add(neighbor, direction == Direction.North || direction == Direction.South)
        }
    }
}
