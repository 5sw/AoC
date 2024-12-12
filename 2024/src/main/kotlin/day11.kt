fun main() {
    val input = readInputString("day11.txt").split(" ").map { it.toLong() }

    val part1 = input.blink(25)
    println("Part 1: $part1")

    val part2 = input.blink(75)
    println("Part 2: $part2")
}

fun List<Long>.blink(count: Int) = fold(0L) { acc, stone -> acc + blink(stone, count) }

val memo = mutableMapOf<Pair<Long, Int>, Long>()
fun blink(stone: Long, count: Int): Long = memo.getOrPut(Pair(stone, count)) {
    if (count == 0) return 1

    val str = "$stone"
    val strLen = str.count()

    when {
        stone == 0L -> blink(1L, count - 1)
        strLen % 2 == 0 ->
            blink(str.substring(0, strLen / 2).toLong(), count - 1) +
                    blink(str.substring(strLen / 2).toLong(), count - 1)

        else -> blink(stone * 2024, count - 1)
    }
}
