fun readInput(name: String) = bufferedReader(name)
    ?.lineSequence()
    ?: error("Cannot read input")

fun readInputString(name: String): String = bufferedReader(name)?.readText() ?: error("Cannot read input")

private fun bufferedReader(name: String) = object {}.javaClass.getResourceAsStream(name)
    ?.bufferedReader()
