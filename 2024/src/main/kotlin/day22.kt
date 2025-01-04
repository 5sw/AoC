fun main() {
    val part1 =  readInput("day22.txt")
        .map { it.toLong() }
        .map { randomSequence(it).elementAt(2000) }
        .sum()

    println("Part 1: $part1")
}

fun prune(x: Long) = x % 16777216
fun mix(a: Long, b: Long) = a xor b

fun randomSequence(start: Long) = generateSequence(start) { current ->
    val a = prune(mix(current, current * 64))
    val b = prune(mix(a, a / 32))
    prune(mix(b, b * 2048))
}