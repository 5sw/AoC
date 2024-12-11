interface Grid<T> {
    val width: Int
    val height: Int

    fun <U> map(fn: (T) -> U): Grid<U>

    fun get(x: Int, y: Int): T

    data class Coordinate(val x: Int, val y: Int)

    fun inside(coordinate: Coordinate) = coordinate.x in 0..<width && coordinate.y in 0..<height
}

operator fun <T> Grid<T>.get(coordinate: Grid.Coordinate) = get(coordinate.x, coordinate.y)
operator fun <T> Grid<T>.contains(coordinate: Grid.Coordinate) = inside(coordinate)

class ListGrid<T>(override val width: Int, override val height: Int, private val content: List<T>) : Grid<T> {
    init {
        assert(width * height == content.count())
    }

    override fun get(x: Int, y: Int): T = content[x + y * width]

    override fun <U> map(fn: (T) -> U): Grid<U> = ListGrid(width, height, content.map(fn))
}
