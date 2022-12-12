import Foundation

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

enum MatrixError: Error {
    case invalidShape
}

extension Matrix<Character> {
    init(contentsOf url: URL) async throws {
        var data: [Character] = []
        var width: Int? = nil
        var height = 0
        
        for try await line in url.lines {
            guard width == nil || width == line.count else {
                throw MatrixError.invalidShape
            }
            width = line.count
            height += 1
            data.append(contentsOf: Array(line))
        }
        
        self.init(width: width ?? 0, height: height, data: data)
    }
}

var startX = 0
var startY = 0
var goalX = 0
var goalY = 0

let input = try await Matrix(contentsOf: URL(fileURLWithPath: "day12.input")).mapIndexed { x, y, element in 
    switch element {
    case "S":
        startX = x
        startY = y
        return 0
        
    case "E":
        goalX = x
        goalY = y
        return Int(UInt8(ascii: "z") - UInt8(ascii: "a"))
    
    case "a"..."z":
        return Int(UInt8(ascii: element.unicodeScalars.first!) - UInt8(ascii: "a"))
        
    default:
        preconditionFailure("Invalid input")
    }
}

protocol Map {
    associatedtype Node: Hashable
    associatedtype Distance: Comparable & AdditiveArithmetic = Int
    
    func neighbors(for node: Node) -> [Node]
    func allNodes() -> [Node]

    func distance(from: Node, to: Node) -> Distance
}

extension Map where Distance == Int {
    func distance(from: Node, to: Node) -> Int { 
        1 
    }
}

struct PathFinder<M: Map> {
    typealias Node = M.Node
    typealias Distance = M.Distance
    
    let map: M
    var distance: [Node: Distance] = [:]
    var predecessors: [Node: Node] = [:]
    var all: Set<Node>
    
    init(_ map: M) {
        self.map = map
        all = Set(map.allNodes())
    }
    
    mutating func findPath(from: Node, to: Node) -> [Node]? {
        distance[from] = .zero
        
        while true {
            guard let next = popClosest() else { break } 
            
            for node in map.neighbors(for: next) where all.contains(node) {
                updateDistance(from: next, to: node)
            }
        }
        
        let result = buildPath(to: to)
        return result.first == from ? result : nil
    }
    
    func buildPath(to node: Node) -> [Node] {
        var path: [Node] = [node]
        var current = node
        while let next = predecessors[current] {
            path.insert(next, at: 0)
            current = next
        }
        return path
    }
    
    mutating func popClosest() -> Node? {
        // TODO: Priority queue based implementation.
        let first = distance.filter { all.contains($0.key) }
            .sorted { $0.value < $1.value }
            .first?.key
            
        guard let node = first else {
            return nil
        }
        
        all.remove(node)
        return node
    }
    
    mutating func updateDistance(from: Node, to: Node) {
        let alternative = distance[from]! + map.distance(from: from, to: to)
        let previous = distance[to]
        if previous == nil || alternative < previous! {
            distance[to] = alternative
            predecessors[to] = from
        }
    }
}

extension Map {
    
    func findPath(from: Node, to: Node) -> [Node]? {
        var pathFinder = PathFinder(self)
        return pathFinder.findPath(from: from, to: to)
    }
}


struct FieldMap: Map {
    struct Node: Hashable {
        var x: Int
        var y: Int
    }
    
    var matrix: Matrix<Int>
    
    subscript(node: Node) -> Int {
        matrix[node.x, node.y]
    }
    
    func left(_ node: Node) -> Node? {
        node.x > 0 ? Node(x: node.x - 1, y: node.y) : nil
    }
    
    func right(_ node: Node) -> Node? {
        node.x < matrix.width - 1 ? Node(x: node.x + 1, y: node.y) : nil
    }
    
    func up(_ node: Node) -> Node? {
        node.y > 0 ? Node(x: node.x, y: node.y - 1) : nil
    }
    
    func down(_ node: Node) -> Node? {
        node.y < matrix.height - 1 ? Node(x: node.x, y: node.y + 1) : nil
    }
    
    func neighbors(for node: Node) -> [Node] {
        var result: [Node] = []
        result.reserveCapacity(4)
        
        let current = self[node] + 1
        
        if let up = up(node), self[up] <= current {
            result.append(up)
        }
        
        if let down = down(node), self[down] <= current {
            result.append(down)
        }
        
        if let left = left(node), self[left] <= current {
            result.append(left)
        }
        
        if let right = right(node), self[right] <= current {
            result.append(right)
        }
        
        return result
    }
    
    func allNodes() -> [Node]  {
        var result: [Node] = []
        result.reserveCapacity(matrix.width * matrix.height)
        for y in 0..<matrix.height {
            for x in 0..<matrix.width {
                result.append(Node(x: x, y: y))
            }
        }
        return result
    }
}

let map = FieldMap(matrix: input)
print("Part 1: steps from start to goal: ", (map.findPath(from: .init(x: startX, y: startY), to: .init(x: goalX, y: goalY))?.count ?? 0) - 1)

var shortest = Int.max
for (x, y) in input.find(where: { $0 == 0 }) {
    if let steps = map.findPath(from: .init(x: x, y: y), to: .init(x: goalX, y: goalY))?.count, steps < shortest {
        shortest = steps
    }
}

print("Part 2: Shortest path to goal: ", shortest - 1)
