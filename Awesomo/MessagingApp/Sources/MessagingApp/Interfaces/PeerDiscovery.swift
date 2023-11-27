//
//  PeerDiscovery.swift
//  MessagingApp
//
//  Created by Vova on 10.11.2023.
//

import Foundation
import Domain

public struct PeerAvailabilityEvent<NetworkAddress: Hashable>: InputEvent {
   public init(event: Event) {
      self.event = event
   }

   public let timestamp = Date()

   public typealias PeerID = Domain.Peer<NetworkAddress>.ID
   public typealias PeerEmergence = Domain.PeerEmergence<NetworkAddress>

   public enum Event: Hashable {
      case peersDidAppear([PeerID: PeerEmergence])
      case peersDidDisappear(Set<PeerID>)
   }
   let event: Event
   public var portID = "PeerAvailability"
}
