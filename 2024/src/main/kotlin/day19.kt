fun main() {
    val iterator = readInput("day19.txt").iterator()

    val towels = Sequence { iterator }.takeWhile { it.isNotEmpty() }
        .flatMap { it.split(",\\s*".toRegex()) }
        .toList()

    val part1 = Sequence { iterator }.count { isPossible(it, towels) }
    println("Part 1: $part1")
}

private val patternMemo = mutableMapOf<String, Boolean>()

fun isPossible(pattern: String, towels: List<String>): Boolean {
    if (pattern.isEmpty()) return true
    return patternMemo.getOrPut(pattern) {
        towels
            .filter { pattern.startsWith(it) }
            .any { isPossible(pattern.substring(it.length), towels) }
    }
}
