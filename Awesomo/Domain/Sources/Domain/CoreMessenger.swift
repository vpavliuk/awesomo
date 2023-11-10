//
//  CoreMessenger.swift
//  Domain
//
//  Created by Vova on 03.11.2023.
//

import Combine

public final class CoreMessenger<NetworkAddress: Hashable> {
   public init() {}

   public typealias ConcretePeer = Peer<NetworkAddress>
   // 'All peers' means currently active peers + offline peers related to the user
   public private(set) var allPeers: [ConcretePeer] = []

   private func handleInput(_ value: Input) {
      switch value {
      case .peersDidAppear(let emergences):
         try! handleEmergedPeers(emergences)
         break
      case .peersDidDisappear(let peerIDs):
         try! handleDisappearedPeers(peerIDs)
         break
      case .messageArrived(let peerId, let message):
         // store message
         break
      case .userAttemptedSendMessage(let sendRequest):
         // store message
         break
      case .outgoingMessageWasSentOverNetwork(_):
         // store message
         break
      }
   }

   public typealias Input = InputEvent<NetworkAddress>
   lazy public var inputInterface: some Subscriber<Input, Never> = Subscribers.Sink<Input, Never>(
      receiveCompletion: { _ in },
      receiveValue: { [weak self] v in self?.handleInput(v) }
   )

   private func handleEmergedPeers(_ emergences: [PeerEmergence<NetworkAddress>]) throws {
      func validate(_ emergences: [PeerEmergence<NetworkAddress>]) throws {
         let emergedPeerIDs = Set(emergences.map(\.peerID))
         if emergedPeerIDs.count < emergences.count {
            throw DomainError.invalidPeerEmergence
         }
      }

      try validate(emergences)

      let emergencesByPeerID = Dictionary(uniqueKeysWithValues: emergences.map { ($0.peerID, $0) })
      var remainingEmergences = Set(emergences)
      for knownPeer in allPeers {
         if let e = emergencesByPeerID[knownPeer.id] {
            try knownPeer.emerge(e)
            remainingEmergences.remove(e)
         }
      }
      allPeers += remainingEmergences.map(Peer.init)
   }

   private func handleDisappearedPeers(_ peerIDs: Set<ConcretePeer.ID>) throws {
      func validate(_ peerIDs: Set<ConcretePeer.ID>) throws {
         let knownPeerIDs = Set(allPeers.map(\.id))
         if !peerIDs.isSubset(of: knownPeerIDs) {
            throw DomainError.invalidPeerDidDisappearEvent
         }
      }

      try validate(peerIDs)

      for knownPeer in allPeers where peerIDs.contains(knownPeer.id) {
         try knownPeer.disappear()
      }

      allPeers.removeAll { $0.isIrrelevant }
   }
}
