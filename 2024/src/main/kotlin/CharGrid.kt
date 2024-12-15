class CharGrid(rows: List<String>) : Grid<Char> {
    val rows = rows.toMutableList()
    override val width = rows.firstOrNull()?.count() ?: 0
    override val height get() = rows.count()

    constructor(width: Int, height: Int, char: Char)
            : this((1..height).map { char.toString().repeat(width) })

    init {
        assert(rows.all { it.length == width })
    }

    companion object {
        fun read(name: String): CharGrid = CharGrid(readInput(name).toList())
    }

    fun chars(x: Int, y: Int, dx: Int, dy: Int) = Line(x, y, dx, dy)

    inner class Line(val x: Int, val y: Int, val dx: Int, val dy: Int) : Sequence<Char> {
        override fun iterator(): Iterator<Char> = if (dx == 1 && dy == 0) {
            rows[y].substring(startIndex = x).iterator()
        } else iterator {
            var x = x
            var y = y

            while (x in 0..<width && y in 0..<height) {
                yield(get(x, y))
                x += dx
                y += dy
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

    override fun get(x: Int, y: Int): Char = rows[y][x]

    fun find(char: Char): Grid.Coordinate? {
        for (y in rows.indices) {
            val index = rows[y].indexOf(char)
            if (index != -1) {
                return Grid.Coordinate(index, y)
            }
        }
        return null
    }

    override fun <T> map(fn: (Char) -> T): Grid<T> {
        val data = rows.flatMap { it.map(fn) }
        return ListGrid(width, height, data)
    }

    override fun set(x: Int, y: Int, value: Char) {
        rows[y] = rows[y].replaceRange(x, x + 1, value.toString())
    }
}
