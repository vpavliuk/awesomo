//
//  CoreMessenger.swift
//  Domain
//
//  Created by Vova on 03.11.2023.
//

import Combine
import Foundation

public final class CoreMessenger<NetworkAddress: Hashable> {
   public init() {}

   public typealias ConcretePeer = Peer<NetworkAddress>
   // 'All peers' means currently active peers + offline peers related to the user
   private var allPeers: [ConcretePeer] = []

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
      updateSnapshot()
   }

   public typealias Input = InputEvent<NetworkAddress>
   lazy public var input: some Subscriber<Input, Never> = Subscribers.Sink<Input, Never>(
      receiveCompletion: { [weak self] completion in
         guard let self else { return }
         outputInternal.send(completion: .finished)
      },
      receiveValue: { [weak self] v in
         self?.handleInput(v)
      }
   )

   public typealias Snapshot = [ConcretePeer.Snapshot]
   private let outputInternal = PassthroughSubject<Snapshot, Never>()
   public var output: some Publisher<Snapshot, Never> { outputInternal }


   public typealias Emergence = PeerEmergence<NetworkAddress>
   private func handleEmergedPeers(_ emergences: [ConcretePeer.ID: Emergence]) throws {
      var remaining = emergences
      for knownPeer in allPeers {
         if let e = remaining.removeValue(forKey: knownPeer.id) {
            try knownPeer.emerge(e)
         }
      }
      allPeers += remaining.map(Peer.init)
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

   private func updateSnapshot() {
      snapshot = allPeers.snapshot()
   }

   private var snapshot: Snapshot = [] {
      didSet {
         if snapshot != oldValue {
            outputInternal.send(snapshot)
         }
      }
   }
}
