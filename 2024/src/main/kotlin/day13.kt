val regex = "Button A: X\\+(\\d+), Y\\+(\\d+)\nButton B: X\\+(\\d+), Y\\+(\\d+)\nPrize: X=(\\d+), Y=(\\d+)".toRegex()

data class Machine(
    val buttonA: Grid.Coordinate,
    val buttonB: Grid.Coordinate,
    val price: Grid.Coordinate
) {

    fun solveA(b: Int) = (price.x - b * buttonB.x) / buttonA.x
    fun solveB() = (price.y * buttonA.x - price.x * buttonA.y) / (buttonA.x * buttonB.y - buttonA.y * buttonB.x)

    fun solve(): Pair<Int, Int>? {
        val b = solveB()
        val a = solveA(b)

        return Pair(a, b).takeIf { (a * buttonA.x + b * buttonB.x) == price.x && (a * buttonA.y + b * buttonB.y) == price.y }
    }
}

fun main() {
    val part1 = regex.findAll(readInputString("day13.txt"))
        .map {
            Machine(
                buttonA = Grid.Coordinate(it.groupValues[1].toInt(), it.groupValues[2].toInt()),
                buttonB = Grid.Coordinate(it.groupValues[3].toInt(), it.groupValues[4].toInt()),
                price = Grid.Coordinate(it.groupValues[5].toInt(), it.groupValues[6].toInt()),
            )
        }
        .mapNotNull { it.solve() }
        .sumOf { (a, b) -> 3 * a + b }

    println("Part 1: $part1")

}