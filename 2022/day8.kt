// kotlinc  day8.kt -include-runtime -d day8.jar && java -jar day8.jar

import java.io.File

class Matrix(
    private val data: List<String>
) {
    val width = data[0].count()
    val height = data.count()

    operator fun get(x: Int, y: Int): Int {
        check(x in 0 until width && y in 0 until height) { "Out of bounds" }
        
        return data[y][x].code - '0'.code
    }
    
    fun column(x: Int): Sequence<Int> {
        check(x in 0 until width) { "Out of bounds" }
        return sequence {
            for (y in 0 until height) yield(get(x, y))
        }
    }
    
    fun row(y: Int): Sequence<Int> {
        check(y in 0 until height) { "Out of bounds" }
        return sequence {
            for (x in 0 until width) yield(get(x, y))
        }
    }
    
    fun reverseColumn(x: Int): Sequence<Int> {
        check(x in 0 until width) { "Out of bounds" }
        return sequence {
            for (y in height - 1 downTo 0) yield(get(x, y))
        }
    }
    
    fun reverseRow(y: Int): Sequence<Int> {
        check(y in 0 until height) { "Out of bounds" }
        return sequence {
            for (x in width - 1 downTo 0) yield(get(x, y))
        }
    }
}

fun Sequence<Int>.findVisibles(): Set<Int> {
    var max = -1
    var result = mutableSetOf<Int>()
    
    for ((index,element) in withIndex()) {
        if (element > max) {
            max = element
            result.add(index)
            
            if (max == 9) break
        }
    }
    
    return result
}

fun Matrix.viewingDistance(x: Int, y: Int, dx: Int, dy: Int): Int {
    var distance = 0
    
    var start = this[x, y]
    
    var cx = x + dx
    var cy = y + dy
    
    while (cx in 0 until width && cy in 0 until height) {
        distance++
        
        if (this[cx, cy] >= start) {
            break
        }    

        cx += dx
        cy += dy
    }
    
    return distance
}

fun Matrix.scenicScore(x: Int, y: Int): Int =
    viewingDistance(x, y, 1, 0) * viewingDistance(x, y, -1, 0) * viewingDistance(x, y, 0, 1) * viewingDistance(x, y, 0, -1)


fun main() {
    val data = File("day8.input").useLines { lines -> 
        lines.toList()
    }

    val matrix = Matrix(data)
    
    
    val visible = mutableSetOf<Pair<Int, Int>>()

    for (row in 0 until matrix.height) {
        visible.addAll(matrix.row(row).findVisibles().map { it to row })
        visible.addAll(matrix.reverseRow(row).findVisibles().map { matrix.width - 1 - it to row })
    }
    
    for (col in 0 until matrix.width) {
        visible.addAll(matrix.column(col).findVisibles().map { col to it })
        visible.addAll(matrix.reverseColumn(col).findVisibles().map { col to matrix.height - 1 - it })
    }
    
    println("Part 1: ${visible.count()}")
    
    var max = 0
    for (x in 1 until matrix.width - 1) {
        for (y in 1 until matrix.height - 1) {
            var score = matrix.scenicScore(x, y)
            if (score > max) {
                max = score
            }
        }
    }
    
    println("Part 2: ${max}")
}
