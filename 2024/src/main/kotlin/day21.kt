fun main() {
    val inputs = listOf(
        "789A",
        "540A",
        "285A",
        "140A",
        "189A",
    )

    val numberPad = CharGrid(
        "789",
        "456",
        "123",
        " 0A"
    )

    val robotPad = CharGrid(
        " ^A",
        "<v>"
    )

    println(keySequence("029A", numberPad))
    println(keySequence(keySequence("029A", numberPad), robotPad))
    Integer.parseInt()
    println("029A".toInt())

}

fun keySequence(code: String, pad: CharGrid, start: Char = 'A'): String {
    var position = pad.find(start) ?: error("Start position not found")
    val gap = pad.find(' ') ?: error("Gap not found")

    val result = StringBuilder()
    for (current in code) {
        val target = pad.find(current) ?: error("Target key not found")

        val dx = target.x - position.x
        val dy = target.y - position.y

        if (target.y < gap.y) {
            result.appendMovement(dy, '^', 'v')
            result.appendMovement(dx, '<', '>')
        } else {
            result.appendMovement(dx, '<', '>')
            result.appendMovement(dy, '^', 'v')
        }

        result.append('A')

        position = target
    }

    return result.toString()
}

fun StringBuilder.appendMovement(amount: Int, less: Char, more: Char): StringBuilder {
    when {
        amount < 0 -> repeat(-amount) { append(less) }
        amount == 0 -> Unit
        else -> repeat(amount) { append(more) }
    }
    return this
}