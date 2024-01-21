//
//  CoreMessenger.swift
//  Domain
//
//  Created by Vova on 03.11.2023.
//

import Foundation
import Combine

public final class CoreMessenger {
   public init() {}

   // 'All peers' means currently active peers + offline peers related to the user in some way
   private var allPeers: [Peer] = []

   public lazy var errors: some Publisher<DomainError, Never> = errorsInternal
   private let errorsInternal: some Subject<DomainError, Never> = PassthroughSubject()

   #warning("TODO: Should not throw after typed throws is added to Swift")
   private func takePeersOnline(_ emergences: [Peer.ID: PeerEmergence]) throws {
      var remaining = emergences
      for knownPeer in allPeers {
         if let e = remaining.removeValue(forKey: knownPeer.id) {
            do {
               try knownPeer.takeOnline(e)
            } catch let error as DomainError {
               errorsInternal.send(error)
            }
         }
      }
      allPeers += remaining.map(Peer.init)
   }

   #warning("TODO: Should not throw after typed throws is added to Swift")
   private func takePeersOffline(_ peerIDs: Set<Peer.ID>) throws {
      func validate(_ peerIDs: Set<Peer.ID>) throws {
         let knownPeerIDs = Set(allPeers.map(\.id))
         let unknownPeerIDs = peerIDs.subtracting(knownPeerIDs)
         if !unknownPeerIDs.isEmpty {
            throw DomainError.cannotTakeOfflineUnknownPeers(unknownPeerIDs)
         }
      }

      do {
         try validate(peerIDs)
      } catch let error as DomainError {
         errorsInternal.send(error)
      }

      for knownPeer in allPeers where peerIDs.contains(knownPeer.id) {
         do {
            try knownPeer.takeOffline()
         } catch let error as DomainError {
            errorsInternal.send(error)
         }
      }
   }

   private func initiateInvitationForPeer(_ peerID: Peer.ID) throws {
      guard let peer = findPeer(by: peerID) else {
         throw DomainError.cannotInviteUknownPeer(peerID)
      }
      try peer.initiateInvitation()
   }

   private func onInvitationSuccessfullySent(to peerID: Peer.ID) throws {
      guard let peer = findPeer(by: peerID) else {
         throw DomainError.cannotHandleInvitationSendingResultForUnknownPeer(peerID)
      }
      try peer.onInvitationSuccesfullySent()
   }

   private func onFailedToSendInvitation(to peerID: Peer.ID) throws {
      guard let peer = findPeer(by: peerID) else {
         throw DomainError.cannotHandleInvitationSendingResultForUnknownPeer(peerID)
      }
      try peer.onFailedToSendInvitation()
   }

   private func onPeerAcceptedInvitation(_ peerID: Peer.ID) throws {
      guard let peer = findPeer(by: peerID) else {
         throw DomainError.unknownPeerCannotRespondToInvitation(peerID)
      }
      try peer.acceptInvitation()
   }

   public typealias State = [Peer.Snapshot]

   #warning("CQS violation")
   public func add(_ input: InputEvent...) -> State {
      var state: State = []
      queue.sync {
         for event in input {
            handleInput(event)
         }
         state = getState()
      }
      return state
   }

   private func handleInput(_ value: InputEvent) {
      func validateInitial(_ value: InputEvent) throws {
         if case .initial = value {
            if receivedInitialEvent {
               throw DomainError.receivedInitialEventTwice
            }
         } else if !receivedInitialEvent {
            throw DomainError.didNotReceiveInitialEvent
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
            try initiateInvitationForPeer(peerID)
         case .invitationForPeerWasSentOverNetwork(let peerID):
            try onInvitationSuccessfullySent(to: peerID)
         case .failedToSendInvitationOverNetwork(let peerID):
            try onFailedToSendInvitation(to: peerID)
         case .userDidAcceptPeersInvitation(let peerID):
            break
         case .messageArrived(_, _):
            // store message
            break
         case .userAttemptedSendMessage(_, _):
            // store message
            break
         case .outgoingMessageWasSentOverNetwork(_):
            // store message
            break
         case .peerAcceptedInvitation(let peerID):
            try onPeerAcceptedInvitation(peerID)
         }
      } catch let error as DomainError {
         errorsInternal.send(error)
      } catch {
         #warning("TODO: After typed throws are implemented in Swift, this catch clause can be removed")
         fatalError("Unexpected error: \(error).")
      }
   }

   private func getState() -> State { allPeers.snapshot() }

   #warning("Use actor?")
   private let queue = DispatchQueue(label: "com.domainQueue", qos: .userInitiated)

   private var receivedInitialEvent = false

   private func findPeer(by id: Peer.ID) -> Peer? {
      allPeers.first { $0.id == id }
   }
}
