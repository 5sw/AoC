fun readInput(name: String) = bufferedReader(name)
    ?.lineSequence()
    ?: error("Cannot read input $name")

fun readInputString(name: String): String = bufferedReader(name)?.readText() ?: error("Cannot read input $name")

private fun bufferedReader(name: String) = object {}.javaClass.getResourceAsStream(name)
    ?.bufferedReader()
