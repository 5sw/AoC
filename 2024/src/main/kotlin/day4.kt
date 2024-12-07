fun main() {
    val grid = Grid.read("day4.txt")

    val part1 = grid.all().fold(0) { acc, line ->
        val string = line.joinToString(separator = "")
        acc + string.countSubstring("XMAS") + string.countSubstring("SAMX")
    }

    println("Part 1: $part1")

    var part2 = 0
    for (y in 1..<(grid.height - 1)) {
        val row = grid.rows[y]
        part2 += row.indices.filter { it > 0 && it < grid.width - 1 && row[it] == 'A' }
            .count { grid.xmasAt(it, y) }
    }
    println("Part 2: $part2")

}

fun Grid.xmasAt(x: Int, y: Int): Boolean {
    assert(get(x, y) == 'A')

    val tl = get(x - 1, y - 1)
    val tr = get(x + 1, y - 1)
    val bl = get(x - 1, y + 1)
    val br = get(x + 1, y + 1)

    val d1 = (tl == 'M' && br == 'S') || (tl == 'S' && br == 'M')
    val d2 = (bl == 'M' && tr == 'S') || (bl == 'S' && tr == 'M')

    return d1 && d2
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