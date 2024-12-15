interface Grid<T> {
    val width: Int
    val height: Int

    fun <U> map(fn: (T) -> U): Grid<U>

    operator fun get(x: Int, y: Int): T
    operator fun set(x: Int, y: Int, value: T)

    data class Coordinate(val x: Int, val y: Int)

    fun inside(coordinate: Coordinate) = coordinate.x in 0..<width && coordinate.y in 0..<height
}

operator fun <T> Grid<T>.set(coordinate: Grid.Coordinate, value: T) = set(coordinate.x, coordinate.y, value)
operator fun <T> Grid<T>.get(coordinate: Grid.Coordinate) = get(coordinate.x, coordinate.y)
operator fun <T> Grid<T>.contains(coordinate: Grid.Coordinate) = inside(coordinate)

fun <T> Grid<T>.coordinates() = sequence {
    for (y in 0..<height) {
        for (x in 0..<width) {
            yield(Grid.Coordinate(x, y))
        }
    }
}

class ListGrid<T>(override val width: Int, override val height: Int,  content: List<T>) : Grid<T> {
    init {
        assert(width * height == content.count())
    }

    private val content = content.toMutableList()

    override fun get(x: Int, y: Int): T = content[x + y * width]
    override fun set(x: Int, y: Int, value: T) {
        content[x + y * width] = value
    }

    override fun <U> map(fn: (T) -> U): Grid<U> = ListGrid(width, height, content.map(fn).toMutableList())
}
