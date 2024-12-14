fun main() {
    val initial = "p=(-?\\d+),(-?\\d+) v=(-?\\d+),(-?\\d+)".toRegex().findAll(readInputString("day14.txt"))
        .map {
            Robot(
                Grid.Coordinate(it.groupValues[1].toInt(), it.groupValues[2].toInt()),
                Grid.Coordinate(it.groupValues[3].toInt(), it.groupValues[4].toInt())
            )
        }
        .toList()

    val robots = initial
        .map { it.move(100) }
        .toList()

    var topLeft = 0
    var topRight = 0
    var bottomLeft = 0
    var bottomRight = 0


    for (robot in robots) {
        require(robot.position.x in 0..<WIDTH)
        require(robot.position.y in 0..<HEIGHT)

        val isTop = robot.position.y < HEIGHT / 2
        val isBottom = robot.position.y > HEIGHT / 2
        val isLeft = robot.position.x < WIDTH / 2
        val isRight = robot.position.x > WIDTH / 2

        when {
            isTop && isLeft -> ++topLeft
            isTop && isRight -> ++topRight
            isBottom && isLeft -> ++bottomLeft
            isBottom && isRight -> ++bottomRight
        }
    }
    val part1 = topLeft * topRight * bottomLeft * bottomRight
    println("Part 1: $part1")
}

private const val WIDTH = 101

private const val HEIGHT = 103

data class Robot(val position: Grid.Coordinate, val velocity: Grid.Coordinate) {
    fun move(t: Int): Robot {
        val newX = (t * WIDTH + position.x + t * velocity.x) % WIDTH
        val newY = (t * HEIGHT + position.y + t * velocity.y) % HEIGHT
        return copy(position = Grid.Coordinate(newX, newY))
    }
}