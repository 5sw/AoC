public struct Array2d<T> {
    public let width: Int
    public let height: Int
    private(set) public var data: [T]

    public init(initial: T, width: Int, height: Int) {
        precondition(width > 0 && height > 0)

        self.width = width
        self.height = height
        data = Array(repeating: initial, count: width * height)
    }

    public subscript(pos: (Int, Int)) -> T {
        get {
            let (x, y) = pos
            precondition(0..<width ~= x)
            precondition(0..<height ~= y)
            return data[x + y * width]
        }
        set(newValue) {
            let (x, y) = pos
            precondition(0..<width ~= x)
            precondition(0..<height ~= y)
            data[x + y * width] = newValue
        }
    }
}
