//
//  Entity.swift
//  Domain
//
//  Created by Vova on 12.11.2023.
//

protocol SnapshotProducer: AnyObject {
   associatedtype Snapshot: Hashable
   func snapshot() -> Snapshot
}

extension Collection where Element: SnapshotProducer {
   func snapshot() -> [Element.Snapshot] {
      map { $0.snapshot() }
   }
}
