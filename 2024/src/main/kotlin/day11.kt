fun main() {
    val input = readInputString("day11.txt").split(" ").map { it.toLong() }

    val part1 = (1..25).fold(input) { result, _ ->
        result.blink()
    }.count()

    println("Part 1: $part1")


    val part2 = (1..75).fold(input) { result, _ ->
        result.blink()
    }.count()

    println("Part 2: $part2")

}

fun List<Long>.blink() = flatMap {
    val str = "$it"
    val strLen = str.count()

    when {
        it == 0L -> listOf(1L)
        strLen % 2 == 0 -> listOf(
            str.substring(0, strLen / 2).toLong(),
            str.substring(strLen / 2).toLong()
        )
        else -> listOf(it * 2024)
    }
}