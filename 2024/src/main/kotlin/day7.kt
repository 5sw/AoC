data class Equation(val test: Long, val numbers: List<Long>) {
    fun canSolve(): Boolean = trySolve(numbers[0], numbers.drop(1))

    private fun trySolve(already: Long, rest: List<Long>): Boolean = when {
        rest.isEmpty() -> already == test
        already > test -> false
        else -> trySolve(already + rest.first(), rest.drop(1)) ||
                trySolve(already * rest.first(), rest.drop(1))
    }


    fun canSolve2(): Boolean = trySolve2(numbers[0], numbers.drop(1))

    private fun trySolve2(already: Long, rest: List<Long>): Boolean = when {
        rest.isEmpty() -> already == test
        already > test -> false
        else -> trySolve2(already + rest.first(), rest.drop(1)) ||
                trySolve2(already * rest.first(), rest.drop(1)) ||
                trySolve2("$already${rest.first()}".toLong(), rest.drop(1))
    }
}

fun main() {
    val equations = readInput("day7.txt").map { line ->
        val (test, equation) = line.split(": ", limit = 2)
        Equation(test.toLong(), equation.split(" ").map { it.toLong() })
    }.toList()

    val part1 = equations.filter { it.canSolve() }.sumOf { it.test }
    println("Part 1: $part1")

    val part2 = equations.filter { it.canSolve2() }.sumOf { it.test }
    println("Part 2: $part2")
}
