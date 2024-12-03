fun main() {
    val input = readInputString("day3.txt")
    val regexPart1 = "mul\\((\\d+),(\\d+)\\)".toRegex()

    val part1 = regexPart1.findAll(input).fold(0) { acc, result ->
        val (a, b) = result.destructured
        acc + a.toInt() * b.toInt()
    }

    println("Part 1: $part1")

    val regexPart2 = "do\\(\\)|don't\\(\\)|mul\\((\\d+),(\\d+)\\)".toRegex()
    var enabled = true
    var part2 = 0
    for (command in regexPart2.findAll(input)) {
        when (command.value) {
            "do()" -> enabled = true
            "don't()" -> enabled = false
            else -> if (enabled) {
                val (a, b) = command.destructured
                part2 += a.toInt() * b.toInt()
            }
        }
    }
    println("Part 2: $part2")
}