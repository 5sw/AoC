fun main() {
    val iterator = readInput("day19.txt").iterator()

    val towels = Sequence { iterator }.takeWhile { it.isNotEmpty() }
        .flatMap { it.split(",\\s*".toRegex()) }
        .toList()

    val patterns = Sequence { iterator }.toList()

    val part1 = patterns.count { waysToMake(it, towels) > 0 }
    println("Part 1: $part1")

    val part2 = patterns.sumOf { waysToMake(it, towels) }
    println("Part 2: $part2")
}

private val patternMemo = mutableMapOf<String, Long>()

fun waysToMake(pattern: String, towels: List<String>): Long {
    if (pattern.isEmpty()) return 1
    return patternMemo.getOrPut(pattern) {
        towels
            .filter { pattern.startsWith(it) }
            .fold(0) { acc, towel -> acc + waysToMake(pattern.substring(towel.length), towels) }
    }
}
