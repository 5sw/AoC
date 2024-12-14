val regex = "Button A: X\\+(\\d+), Y\\+(\\d+)\nButton B: X\\+(\\d+), Y\\+(\\d+)\nPrize: X=(\\d+), Y=(\\d+)".toRegex()

data class Machine(
    val buttonA: Grid.Coordinate,
    val buttonB: Grid.Coordinate,
    val priceX: Long,
    val priceY: Long
) {

    fun solveA(b: Long) = (priceX - b * buttonB.x) / buttonA.x
    fun solveB() = (priceY * buttonA.x - priceX * buttonA.y) / (buttonA.x * buttonB.y - buttonA.y * buttonB.x)

    fun solve(): Pair<Long, Long>? {
        val b = solveB()
        val a = solveA(b)

        return Pair(
            a,
            b
        ).takeIf { (a * buttonA.x + b * buttonB.x) == priceX && (a * buttonA.y + b * buttonB.y) == priceY }
    }
}

fun main() {
    val machines = regex.findAll(readInputString("day13.txt"))
        .map {
            Machine(
                buttonA = Grid.Coordinate(it.groupValues[1].toInt(), it.groupValues[2].toInt()),
                buttonB = Grid.Coordinate(it.groupValues[3].toInt(), it.groupValues[4].toInt()),
                priceX = it.groupValues[5].toLong(),
                priceY = it.groupValues[6].toLong()
            )
        }
        .toList()

    val part1 = machines.mapNotNull { it.solve() }
        .sumOf { (a, b) -> 3 * a + b }

    println("Part 1: $part1")

    val part2 = machines.map {
        it.copy(
            priceX = it.priceX + 10000000000000,
            priceY = it.priceY + 10000000000000
        )
    }.mapNotNull { it.solve() }
        .sumOf { (a, b) -> 3 * a + b }

    println("Part 2: $part2")
}