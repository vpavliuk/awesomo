//
//  ChatRouter.swift
//
//
//  Created by Vova on 18.12.2023.
//

import SwiftUI
import Domain

final class ChatRouter: NavigationRouter {

   @Published
   var path = NavigationPath()

   func push(_ entity: Peer.ID) {
      path.append(entity)
   }

   func pop() {
      path.removeLast()
   }
}
