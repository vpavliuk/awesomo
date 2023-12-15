//
//  PeerListUserInputHandler.swift
//
//
//  Created by Vova on 04.12.2023.
//

import Domain

struct PeerListUserInputHandler: InputHandler {
   init(coreMessenger: CoreMessenger, completion: @escaping (Peer.ID) -> Void) {
      self.coreMessenger = coreMessenger
      self.completion = completion
   }

   func on(_ event: PeerListUserInput) -> CoreMessenger.State {
      print("Received PeerListUserInput: \(event)")
      switch event {
      case .didSelectPeer(let peerID):
         #warning("Dirty hack")
         return coreMessenger.add(.initial)
      }
   }

   private let coreMessenger: CoreMessenger
   private let completion: (Peer.ID) -> Void
}
