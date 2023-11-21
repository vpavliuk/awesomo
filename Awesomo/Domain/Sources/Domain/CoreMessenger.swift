//
//  CoreMessenger.swift
//  Domain
//
//  Created by Vova on 03.11.2023.
//

import Foundation
import Combine

public final class CoreMessenger<NetworkAddress: Hashable> {
   public init() {}

   public typealias ConcretePeer = Peer<NetworkAddress>
   public typealias PeerID = ConcretePeer.ID
   public typealias ConcreteError = DomainError<NetworkAddress>

   // 'All peers' means currently active peers + offline peers related to the user
   private var allPeers: [ConcretePeer] = []

   public lazy var errors: some Publisher<ConcreteError, Never> = errorsInternal
   private let errorsInternal: some Subject<ConcreteError, Never> = PassthroughSubject()

   public typealias Emergence = PeerEmergence<NetworkAddress>

   #warning("TODO: Should not throw after typed throws is added to Swift")
   private func takePeersOnline(_ emergences: [PeerID: Emergence]) throws {
      var remaining = emergences
      for knownPeer in allPeers {
         if let e = remaining.removeValue(forKey: knownPeer.id) {
            do {
               try knownPeer.takeOnline(e)
            } catch let error as ConcreteError {
               errorsInternal.send(error)
            }
         }
      }
      allPeers += remaining.map(Peer.init)
   }

   #warning("TODO: Should not throw after typed throws is added to Swift")
   private func takePeersOffline(_ peerIDs: Set<PeerID>) throws {
      func validate(_ peerIDs: Set<PeerID>) throws {
         let knownPeerIDs = Set(allPeers.map(\.id))
         let unknownPeerIDs = peerIDs.subtracting(knownPeerIDs)
         if !unknownPeerIDs.isEmpty {
            throw ConcreteError.cannotTakeOfflineUnknownPeers(unknownPeerIDs)
         }
      }

      do {
         try validate(peerIDs)
      } catch let error as ConcreteError {
         errorsInternal.send(error)
      }

      for knownPeer in allPeers where peerIDs.contains(knownPeer.id) {
         do {
            try knownPeer.takeOffline()
         } catch let error as ConcreteError {
            errorsInternal.send(error)
         }
      }
   }

   private func invitePeer(_ peerID: PeerID) throws {
      guard let peer = allPeers.first(where: { $0.id == peerID }) else {
         throw ConcreteError.cannotInviteUknownPeer(peerID)
      }
      try peer.invite()
   }

   private func handlePeerDidAcceptInvitation(_ peerID: PeerID) throws {
      guard let peer = allPeers.first(where: { $0.id == peerID }) else {
         throw ConcreteError.unknownPeerCannotAcceptInvitation(peerID)
      }
      try peer.acceptInvitation()
   }

   public typealias Input = InputEvent<NetworkAddress>
   public typealias Snapshot = [ConcretePeer.Snapshot]

   #warning("CQS violation")
   public func add(_ input: Input...) -> Snapshot {
      var state: Snapshot = []
      inputQueue.sync {
         for event in input {
            handleInput(event)
         }
         state = snapshot()
      }
      return state
   }

   private func handleInput(_ value: Input) {
      func validateInitial(_ value: Input) throws {
         if case .initial = value {
            if receivedInitialEvent {
               throw ConcreteError.receivedInitialEventTwice
            }
         } else if !receivedInitialEvent {
            throw ConcreteError.didNotReceiveInitialEvent
         }
      }

      func removeIrrelevantPeers() {
         allPeers.removeAll { $0.isIrrelevant }
      }
      defer { removeIrrelevantPeers() }

      do {
         try validateInitial(value)

         switch value {
         case .initial:
            receivedInitialEvent = true
         case .peersDidAppear(let emergences):
            try takePeersOnline(emergences)
         case .peersDidDisappear(let peerIDs):
            try takePeersOffline(peerIDs)
         case .userDidInvitePeer(let peerID):
            try invitePeer(peerID)
         case .messageArrived(_, _):
            // store message
            break
         case .userAttemptedSendMessage(_, _):
            // store message
            break
         case .outgoingMessageWasSentOverNetwork(_):
            // store message
            break
         case .peerDidAcceptInvitation(let peerID):
            try handlePeerDidAcceptInvitation(peerID)
         }
      } catch let error as ConcreteError {
         errorsInternal.send(error)
      } catch {
         #warning("TODO: After typed throws are implemented in Swift, this catch clause can be removed")
         fatalError("Unexpected error: \(error).")
      }
   }

   private func snapshot() -> Snapshot {
      allPeers.snapshot()
   }

   #warning("Use actor?")
   private let inputQueue = DispatchQueue(label: "com.domainQueue", qos: .userInitiated)

   private var receivedInitialEvent = false
}
