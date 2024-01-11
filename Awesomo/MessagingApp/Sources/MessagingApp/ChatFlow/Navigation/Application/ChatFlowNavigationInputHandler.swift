//
//  ChatFlowNavigationInputHandler.swift
//
//
//  Created by Vova on 11.01.2024.
//

import Domain
import Combine

final class ChatFlowNavigationPopHandler<Router: NavigationRouter>: InputHandler where Router.Entity == Peer.ID {

   init(coreMessenger: CoreMessenger, router: Router) {
      self.coreMessenger = coreMessenger
      self.router = router
   }

   func on(_: ChatFlowNavigationPop) -> CoreMessenger.State {
      router.pop()
      return coreMessenger.add(.initial)
   }

   private let coreMessenger: CoreMessenger
   private var router: Router
}
