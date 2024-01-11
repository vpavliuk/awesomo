//
//  PeerListUserInputHandler.swift
//
//
//  Created by Vova on 04.12.2023.
//

import Domain
import Combine

struct PeerListUserInputHandler<Router: NavigationRouter>: InputHandler where Router.Entity == Peer.ID {

   init(coreMessenger: CoreMessenger, chatRouter: Router) {
      self.coreMessenger = coreMessenger
      self.chatRouter = chatRouter
   }

   func on(_ event: PeerListUserInput) -> CoreMessenger.State {
      switch event {
      case .didSelectPeer(let peerID):
         chatRouter.push(peerID)
         #warning("Dirty hack")
         return coreMessenger.add(.initial)
      }
   }

   private let coreMessenger: CoreMessenger
   private let chatRouter: Router
}
