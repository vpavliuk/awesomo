//
//  NonEmpty.swift
//  Utils
//
//  Created by Vova on 27.11.2023.
//

public struct NonEmpty<Element> {
   private let head: Element
   private let tail: [Element]
}

extension NonEmpty {
   public init?(_ collection: some Collection<Element>) {
      guard let first = collection.first else { return nil }
      head = first
      tail = Array(collection.dropFirst())
   }
}

extension NonEmpty: RandomAccessCollection {
   public var startIndex: Int { 0 }
   public var endIndex: Int { tail.endIndex + 1 }

   public func formIndex(after i: inout Int) { i += 1 }
   public func formIndex(before i: inout Int) { i -= 1 }
   public subscript(index: Int) -> Element { index == 0 ? head : tail[index - 1] }
}
