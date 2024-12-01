struct Matrix<Element> {
    var width: Int
    var height: Int
    var data: [Element]
    
    init(width: Int, height: Int, data: [Element]) {
        precondition(data.count == width * height)
        self.width = width
        self.height = height
        self.data = data
    }
    
    subscript(x: Int, y: Int) -> Element {
        get {
            precondition(0 <= x && x < width && 0 <= y && y < height)
            return data[x + width * y]
        }
        set {
            precondition(0 <= x && x < width && 0 <= y && y < height)
            data[x + width * y] = newValue
        }
    }
}

extension Matrix {
    func map<T>(_ transform: (Element) throws -> T) rethrows -> Matrix<T> {
        Matrix<T>(width: width, height: height, data: try data.map(transform))
    }
    
    func mapIndexed<T>(_ transform: (Int, Int, Element) throws -> T) rethrows -> Matrix<T> {
        var newData: [T] = []
        newData.reserveCapacity(data.count)
        var index = 0
        for y in 0..<height {
            for x in 0..<width {
                newData.append(try transform(x, y, data[index]))
                index += 1
            }
        }
        
        return Matrix<T>(width: width, height: height, data: newData)
    }

    func find(where: (Element) throws -> Bool) rethrows -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        var index = 0
        for y in 0..<height {
            for x in 0..<width {
                if (try `where`(data[index])) {
                    result.append((x, y))
                }
                index += 1
            }
        }

        return result
    }
}
