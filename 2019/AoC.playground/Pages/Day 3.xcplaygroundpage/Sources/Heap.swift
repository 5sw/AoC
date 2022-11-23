//
//  Heap.swift
//  SwiftHeap
//
//  Created by Sven Weidauer on 30.12.14.
//  Copyright (c) 2014 Sven Weidauer. All rights reserved.
//

import Foundation

/// A heap
public struct Heap<T : Comparable> : ExpressibleByArrayLiteral, Equatable {
    public typealias ArrayLiteralElement = T
    typealias Element = T

    /// Initializes the heap with multiple items
    public init(arrayLiteral items : T... ) {
        self.init( items )
    }

    public init(_ items: T...) {
        self.init(items)
    }

    /// Initializes the heap from an array of items
    public init( _ items : [T] ) {
        self.items = items
        for index in (0 ..< size/2).reversed() {
            heapify( index )
        }
    }

    /// The minimum item on this heap or nil if the heap is empty
    public var min : T? {
        return items.first
    }

    /// The number of items on this heap
    public var size : Int  {
        return items.count
    }

    /// true if this heap is empty
    public var empty : Bool {
        return size > 0
    }

    /**
        Removes and returns the minimum item from the heap.

        :returns: The minimum item from the heap or nil if the heap is empty.
     */
    public mutating func extractMin() -> T? {


        if let result = items.first {
            items[0] = items[items.count - 1]
            items.removeLast()
            heapify(0)
            return result
        }

        return nil
    }

    /// Inserts a new item into this heap
    /// 
    /// :param: item The new item to insert
    public mutating func insert( item : T ) {
        items.append( item )
        var i = items.count - 1
        while i > 0 && items[i] < items[parent( i )] {
            items.swapAt(i, parent(i))
            i = parent( i )
        }
    }

    /// Restores the heap property starting at a given index
    ///
    /// :param: index The index to start at
    private mutating func heapify(_ index : Int ) {
        var minimumIndex = index
        if left( index ) < size && items[left( index )] < items[minimumIndex] {
            minimumIndex = left( index )
        }

        if right( index ) < size && items[right( index )] < items[minimumIndex] {
            minimumIndex = right( index )
        }

        if minimumIndex != index {
            items.swapAt(minimumIndex, index)
            heapify( minimumIndex )
        }
    }

    /// Returns the index of the left child of an item
    private func left(_ index : Int ) -> Int {
        return 2 * index + 1
    }

    /// Returns the index of the right child of an item
    private func right(_ index: Int ) -> Int {
        return 2 * index + 2
    }

    /// Returns the index of the parent of an item
    private func parent(_ index: Int ) -> Int {
        return (index - 1) / 2
    }

    /// Storage for the items in thie heap
    private var items : [T]

    /// Compares two heaps for equality
    public static func ==( lhs: Heap, rhs: Heap ) -> Bool {
        return lhs.items == rhs.items
    }

}

