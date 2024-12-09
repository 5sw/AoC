sealed class Span {
    abstract val length: Int

    data class Empty(override val length: Int): Span()
    data class File(val id: Int, override val  length: Int): Span()
}

fun main() {
    var currentFileId = 0
    val disk = readInputString("day9.txt").mapIndexed { index, c ->
        if (index % 2 == 0) {
            Span.File(currentFileId++, c.digitToInt())
        } else {
            Span.Empty(c.digitToInt())
        }
    }.toMutableList()

    fun take(blocks: Int): Span.File {
        var block: Span
        do {
            block = disk.removeLast()
        } while (block !is Span.File)

        if (block.length > blocks) {
            disk.add(Span.File(block.id, block.length - blocks))
            return Span.File(block.id, blocks)
        }

        return block
    }

    var index = 1
    while (index < disk.count()) {
        require(disk[index] is Span.Empty)

        val freeSpace = disk[index].length
        val fillData = take(freeSpace)
        disk[index] = fillData

        if (fillData.length < freeSpace) {
            disk.add(index + 1, Span.Empty(freeSpace - fillData.length))
            index += 1
        } else {
            index += 2
        }
    }

    val checkSum = calculateCheckSum(disk)
    println("Part 1: $checkSum")
}

private fun calculateCheckSum(disk: List<Span>): Long {
    var checkSum = 0L
    var currentBlock = 0L

    for (file in disk) {
        require(file is Span.File)

        repeat(file.length) {
            checkSum += currentBlock++ * file.id
        }
    }

    return checkSum
}
