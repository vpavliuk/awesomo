//
//  PeerListUserInputHandler.swift
//
//
//  Created by Vova on 04.12.2023.
//

import Domain

struct PeerListUserInputHandler: InputHandler {
   init(completion: @escaping (Peer.ID) -> Void) {
      self.completion = completion
   }

   func on(_ event: PeerListUserInput) {
      switch event {
      case .didSelectPeer(let peerID):
         completion(peerID)
      }
   }

   let completion: (Peer.ID) -> Void
}
