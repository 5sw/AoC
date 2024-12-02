fun readInput(name: String) = object {}.javaClass.getResourceAsStream(name)
    ?.bufferedReader()
    ?.lineSequence()
    ?: error("Cannot read input")
