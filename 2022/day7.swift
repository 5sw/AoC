import Foundation

class Directory {
    var parent: Directory? = nil
    var children: [String: Directory] = [:]
    var size: Int = 0
    
    init(parent: Directory? = nil) {
        self.parent = parent
    }
    
    func child(_ name: String) -> Directory {
        if let child = children[name] {
            return child
        }
        
        let new = Directory(parent: self)
        children[name] = new
        return new
    }
    
    func totalSize() -> Int {
        return size + children.values.reduce(0) { $0 + $1.totalSize() }
    }
    
    func all(_ callback: (Directory) -> Void) {
        callback(self)
        for child in children.values {
            child.all(callback)
        }
    }
}

let input = try String(contentsOf: URL(fileURLWithPath: "day7.input"))
let scanner = Scanner(string: input)

let root = Directory()
var current: Directory? = nil

while !scanner.isAtEnd {
    guard scanner.scanString("$") != nil else {
        fatalError("Expected $")
    }
    
    if scanner.scanString("cd") != nil, let dir = scanner.scanUpToString("\n") {
        switch dir {
            case "/": 
                current = root
                
            case "..":
                current = current!.parent
                
            default:
                current = current!.child(dir)
        }
    } else if scanner.scanString("ls") != nil {
        while true {
            if let size = scanner.scanInt() {
                current!.size += size
            } else if scanner.scanString("dir") != nil {
                
            } else {
                break
            }
            _ = scanner.scanUpToString("\n");
        }
    }
}

var sum = 0
root.all {
    let size = $0.totalSize()
    if size < 100000 {
        sum += size
    }
}

print("Part 1: Sum of size of all directories < 100000:", sum)

let diskSize = 70000000
let freeSpace = diskSize - root.totalSize()
let requiredSize = 30000000
let toFree = requiredSize - freeSpace

var smallest = Int.max
root.all {
    let size = $0.totalSize()
    if size >= toFree && size < smallest {
        smallest = size
    }
}

print("Part 2: Smallest folder to delete:", smallest)
