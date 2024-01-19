//
//  PeerListUserInputHandler.swift
//
//
//  Created by Vova on 04.12.2023.
//

import Domain
import Combine

struct PeerListUserInputHandler<Router: NavigationRouter>: InputEventHandler where Router.Entity == Peer.ID {

   init(chatRouter: Router) {
      self.chatRouter = chatRouter
   }

   func on(_ event: PeerListUserInput) {
      switch event {
      case .didSelectPeer(let peerID):
         chatRouter.push(peerID)
      }
   }

   private let chatRouter: Router
}
