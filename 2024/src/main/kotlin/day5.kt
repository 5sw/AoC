fun main() {

    val rules = mutableListOf<Pair<Int, Int>>()
    var completedRules = false

    var part1 = 0
    var part2 = 0

    for (line in readInput("day5.txt")) {
        if (completedRules) {
            val job = line.split(",").map { it.toInt() }
            assert(job.count() % 2 != 0)

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
                val middlePage = job[job.count() / 2]
                part1 += middlePage
            } else {
                val usedRules = rules.filter { (first, second) -> job.contains(first) && job.contains(second) }

                val pages = mutableMapOf<Int, Page>()
                for (rule in usedRules) {
                    val first = pages.getOrPut(rule.first) { Page(rule.first) }
                    val second = pages.getOrPut(rule.second) { Page(rule.second) }

                    second.previous.add(first)
                }

                val orderedJob = pages.values.sortedBy { it.previous.count() }.map { it.number }

                val middlePage = orderedJob[orderedJob.count() / 2]
                part2 += middlePage
            }
        } else if (line.isEmpty()) {
            completedRules = true
        } else {
            val (first, second) = line.split("|", limit = 2).map { it.toInt() }
            rules.add(first to second)
        }
    }

    println("Part 1: $part1")
    println("Part 2: $part2")
}

data class Page(val number: Int) {
    val previous = mutableSetOf<Page>()
}