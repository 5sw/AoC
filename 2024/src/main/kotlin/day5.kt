fun main() {

    val rules = mutableListOf<Pair<Int, Int>>()
    var completedRules = false

    var part1 = 0

    for (line in readInput("day5.txt")) {
        if (completedRules) {
            val job = line.split(",").map { it.toInt() }
            assert(job.count() % 2 != 0)
            val middlePage = job[job.count() / 2]

            var matches = true
            for ((first, second) in rules) {
                val firstIndex = job.indexOf(first)
                val secondIndex = job.indexOf(second)

                if (firstIndex != -1 && secondIndex != -1 && firstIndex > secondIndex) {
                    matches = false
                    break
                }
            }

            if (matches) {
                part1 += middlePage
            }
        } else if (line.isEmpty()) {
            completedRules = true
        } else {
            val (first, second) = line.split("|", limit = 2).map { it.toInt() }
            rules.add(first to second)
        }
    }

    println("Part 1: $part1")

}