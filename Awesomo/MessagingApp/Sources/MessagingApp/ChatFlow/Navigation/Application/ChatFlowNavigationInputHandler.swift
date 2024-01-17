//
//  ChatFlowNavigationInputHandler.swift
//
//
//  Created by Vova on 11.01.2024.
//

import Domain
import Combine

struct ChatFlowNavigationPopHandler<Router: NavigationRouter>: InputEventHandler where Router.Entity == Peer.ID {

   internal init(router: Router) {
      self.router = router
   }

   func on(_: ChatFlowNavigationPop) {
      router.pop()
   }

   private var router: Router
}
