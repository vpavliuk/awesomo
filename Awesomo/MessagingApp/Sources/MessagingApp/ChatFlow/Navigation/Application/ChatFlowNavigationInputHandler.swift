//
//  ChatFlowNavigationInputHandler.swift
//
//
//  Created by Vova on 11.01.2024.
//

import Domain
import Combine

final class ChatFlowNavigationPopHandler<Router: NavigationRouter>: InputHandler where Router.Entity == Peer.ID {

   init(router: Router) {
      self.router = router
   }

   func on(_: ChatFlowNavigationPop) {
      router.pop()
   }

   private var router: Router
}
