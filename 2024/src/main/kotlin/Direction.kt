enum class Direction {
    North,
    East,
    South,
    West;

    fun turnClockwise() = when(this) {
        North -> East
        East -> South
        South -> West
        West -> North
    }
}

fun Grid.Coordinate.step(direction: Direction) =
    when (direction) {
        Direction.North -> copy(y = y - 1)
        Direction.East -> copy(x = x + 1)
        Direction.South -> copy(y = y + 1)
        Direction.West -> copy(x = x - 1)
    }