fun main() {
    val grid = Grid.read("day4.txt")

    val part1 = grid.all().fold(0) { acc, line ->
        val string = line.joinToString(separator = "")
        println(string)

        acc + string.countSubstring("XMAS") + string.countSubstring("SAMX")
    }

    println("Part 1: $part1")
}

fun String.countSubstring(substring: String): Int {
    var start = 0
    var count = 0

    while (true) {
        val next = indexOf(substring, start)
        if (next == -1) break

        count++
        start = next + substring.length
    }

    return count
}