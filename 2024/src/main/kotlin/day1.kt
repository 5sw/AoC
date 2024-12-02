import kotlin.math.abs

fun main() {
    val input = readInput("day1.txt")

    val a = mutableListOf<Int>()
    val b = mutableListOf<Int>()

    val spaces = "\\s+".toRegex()

    for (line in input) {
        val parts = line.split(spaces, limit = 2)
        val (first, second) = parts
        a.add(first.toInt())
        b.add(second.toInt())
    }

    assert(a.size == b.size)
    a.sort()
    b.sort()

    var sum = 0
    for (index in a.indices) {
        sum += abs(a[index] - b[index])
    }

    println("Part 1: $sum")


    sum = 0

    for (value in a) {
        sum += value * b.count { it == value }
    }

    println("Part 2: $sum")
}
