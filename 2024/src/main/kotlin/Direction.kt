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

fun Grid.Coordinate.step(direction: Direction, steps: Int = 1) =
    when (direction) {
        Direction.North -> copy(y = y - steps)
        Direction.East -> copy(x = x + steps)
        Direction.South -> copy(y = y + steps)
        Direction.West -> copy(x = x - steps)
    }