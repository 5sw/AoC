sealed class Span {
    abstract val length: Int

    data class Empty(override val length: Int) : Span()
    data class File(val id: Int, override val length: Int) : Span()
}


fun main() {
    var currentFileId = 0

    val input = readInputString("day9.txt").mapIndexed { index, c ->
        if (index % 2 == 0) {
            Span.File(currentFileId++, c.digitToInt())
        } else {
            Span.Empty(c.digitToInt())
        }
    }

    println("Part 1: ${part1(input)}")
    println("Part 2: ${part2(input)}")
}

private fun part1(input: List<Span>): Long {
    val disk = input.toMutableList()

    var index = 1
    while (index < disk.count()) {
        require(disk[index] is Span.Empty)

        val freeSpace = disk[index].length
        val fillData = disk.takeFileBlocksFromEnd(freeSpace)
        disk[index] = fillData

        if (fillData.length < freeSpace) {
            disk.add(index + 1, Span.Empty(freeSpace - fillData.length))
            index += 1
        } else {
            index += 2
        }
    }

    return disk.calculateCheckSum()
}

private fun part2(input: List<Span>): Long {
    val disk = input.toMutableList()

    var index = disk.lastIndex
    while (index > 0) {
        val file = disk[index]
        if (file !is Span.File) {
            --index
            continue
        }

        val target = disk.subList(0, index).indexOfFirst {
            it is Span.Empty && it.length >= file.length
        }

        if (target != -1) {
            disk[index] = Span.Empty(file.length)

            val space = disk[target]

            require(space is Span.Empty)

            disk[target] = file
            if (space.length > file.length) {
                disk.add(target + 1, Span.Empty(space.length - file.length))
                ++index
            }
        }

        --index
    }

    return disk.calculateCheckSum()
}

private fun MutableList<Span>.takeFileBlocksFromEnd(blocks: Int): Span.File {
    var block: Span
    do {
        block = removeLast()
    } while (block !is Span.File)

    if (block.length > blocks) {
        add(Span.File(block.id, block.length - blocks))
        return Span.File(block.id, blocks)
    }

    return block
}


private fun List<Span>.calculateCheckSum(): Long {
    var checkSum = 0L
    var currentBlock = 0L

    for (file in this) {
        when (file) {
            is Span.Empty -> currentBlock += file.length
            is Span.File -> repeat(file.length) {
                checkSum += currentBlock++ * file.id
            }
        }
    }

    return checkSum
}
