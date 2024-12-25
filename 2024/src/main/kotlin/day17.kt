/*
Register A: 21539243
Register B: 0
Register C: 0

Program: 2,4,1,3,7,5,1,5,0,3,4,1,5,5,3,0
 */

class Computer(var a: Int = 0, var b: Int = 0, var c: Int = 0, var ip: Int = 0, val memory: List<Int>) {
    val output = mutableListOf<Int>()

    fun run(): List<Int> {
        ip = 0
        output.clear()

        while (0 <= ip && (ip + 1) < memory.size) {
            when (memory[ip]) {
                0 -> a /= (1 shl comboOperand())
                1 -> b = b xor literalOperand()
                2 -> b = comboOperand() and 7
                3 -> if (a != 0) {
                    ip = literalOperand() - 2
                }
                4 -> b = b xor c
                5 -> output.add(comboOperand() and 7)
                6 -> b = a / (1 shl comboOperand())
                7 -> c = a / (1 shl comboOperand())
                else -> error("Invalid opcode ${memory[ip]}")
            }
            ip += 2
        }
        return output.toList()
    }

    private fun comboOperand(): Int = when(val value = memory[ip + 1]) {
        0, 1, 2, 3 -> value
        4 -> a
        5 -> b
        6 -> c
        else -> error("Invalid combo operand $value")
    }

    private fun literalOperand(): Int = memory[ip + 1]

}

fun main() {
    val computer = Computer(a = 21539243, memory = listOf(2,4,1,3,7,5,1,5,0,3,4,1,5,5,3,0))
    val output = computer.run().joinToString(separator = ",")
    println("Part 1: $output")
}