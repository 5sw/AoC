class Grid(val rows: List<String>) {
    val width = rows.firstOrNull()?.count() ?: 0
    val height get() = rows.count()

    init {
        assert(rows.all { it.length == width })
    }

    companion object {
        fun read(name: String): Grid = Grid(readInput(name).toList())
    }

    fun chars(x: Int, y: Int, dx: Int, dy: Int) = Line(x, y, dx, dy)

    inner class Line(val x: Int, val y: Int, val dx: Int, val dy: Int) : Sequence<Char> {
        override fun iterator(): Iterator<Char> = iterator {
            if (dx == 1 && dy == 0) {
                yieldAll(rows[y].substring(startIndex = x).asSequence())
            } else {

                var x = x
                var y = y

                while (x in 0..<width && y in 0..<height) {
                    yield(get(x, y))
                    x += dx
                    y += dy
                }
            }
        }
    }

    fun rows(): Sequence<Line> = sequence {
        for (y in 0..<height) {
            yield(chars(0, y, 1, 0))
        }
    }

    fun columns(): Sequence<Line> = sequence {
        for (x in 0..<width) {
            yield(chars(x, 0, 0, 1))
        }
    }

    fun diagonals(): Sequence<Line> = sequence {
        for (x in 0..<width) {
            yield(chars(x, 0, 1, 1))
            if (x > 0) {
                yield(chars(x, 0, -1, 1))
            }
        }
        for (y in 1..<height) {
            yield(chars(0, y, 1, 1))
            yield(chars(width - 1, y, -1, 1))
        }
    }

    fun all(): Sequence<Line> = sequence {
        yieldAll(rows())
        yieldAll(columns())
        yieldAll(diagonals())
    }

    fun get(x: Int, y: Int): Char = rows[y][x]

}
