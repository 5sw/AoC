fun main() {
    val grid = Grid.read("day8.txt")

    val antennasByFrequency = mutableMapOf<Char, MutableList<Grid.Coordinate>>()
    for (y in 0..<grid.height) {
        for (x in 0..<grid.width) {
            val value = grid.get(x, y)
            if (value != '.') {
                antennasByFrequency.getOrPut(value) { mutableListOf() }.add(Grid.Coordinate(x, y))
            }
        }
    }

    fun isAntinode(coordinate: Grid.Coordinate, frequency: Char, antennas: List<Grid.Coordinate>) =
        antennas.any { antenna ->
            val dx = antenna.x - coordinate.x
            val dy = antenna.y - coordinate.y
            val secondAntenna = Grid.Coordinate(antenna.x + dx, antenna.y + dy)

            secondAntenna != antenna && grid.inside(secondAntenna) && grid[secondAntenna] == frequency
        }

    fun isAntinode(coordinate: Grid.Coordinate) =
        antennasByFrequency.any { (frequency, positions) ->
            isAntinode(coordinate, frequency, positions)
        }

    val antinodes = mutableSetOf<Grid.Coordinate>()

    for (y in 0..<grid.height) {
        for (x in 0..<grid.width) {

            val coordinate = Grid.Coordinate(x, y)
            if (isAntinode(coordinate)) {
                antinodes.add(coordinate)
            }

        }
    }

    println("Part 1: ${antinodes.count()}")
}
