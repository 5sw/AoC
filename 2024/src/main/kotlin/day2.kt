import kotlin.math.abs

fun main() {
    val input = readInput("day2.txt")
        .map { line -> line.split(" ").map { it.toInt() } }

    val safe = input.count { isSafe(it) }
    println("Part 1: $safe")
}

private fun isSafe(report: List<Int>): Boolean {
    data class State(val increasing: Boolean? = null, val last: Int? = null, val safe: Boolean = true, val usedProblemDampener: Boolean = false) {
        fun update(next: Int): State = when {
            !safe -> this
            last == null -> copy(last = next)
            increasing == null -> copy(increasing = last < next, last = next, safe = safeIncrement(last, next))
            increasing -> copy(last = next, safe = safeIncrement(last, next) && last < next)
            else -> copy(last = next, safe = safeIncrement(last, next) && last > next)
        }.problemDampener()

        fun safeIncrement(last: Int, next: Int): Boolean = abs(last - next) in 1..3

        fun problemDampener() = when {
            !safe && !usedProblemDampener -> copy(safe = true, usedProblemDampener = true)
            else -> this
        }
    }

    return report.fold(State()) { state, next ->
        state.update(next)
            .also { if (!it.safe) return@isSafe false }
    }.safe
}
