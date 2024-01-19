//
//  PeerListFactory.swift
//
//
//  Created by Vova on 18.01.2024.
//

import Domain

enum PeerListFactory {

   static func getViewModel(router: some NavigationRouter<Peer.ID>) -> PeerListViewModel {
      return CommonFactory
         .viewModelBuilder
         .buildInteractiveViewModel(
            of: PeerListViewModel.self,
            userInputHandler: getUserInputHandler(router: router)
         )
   }

   private static func getUserInputHandler(router: some NavigationRouter<Peer.ID>)
      -> some InputEventHandler<PeerListUserInput> { PeerListUserInputHandler(chatRouter: router) }
}
