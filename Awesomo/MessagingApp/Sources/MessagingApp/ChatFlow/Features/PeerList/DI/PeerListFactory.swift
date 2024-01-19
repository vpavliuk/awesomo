//
//  PeerListFactory.swift
//
//
//  Created by Vova on 18.01.2024.
//

import Domain

enum PeerListFactory {

   static func getViewModel(router: some NavigationRouter<Peer.ID>) -> PeerListViewModel {
      let handlerStore = CommonFactory.eventHandlerStore
      let eventType = PeerListUserInput.self

      if !handlerStore.isHandlerRegistered(for: eventType) {
         let handler = getUserInputHandler(witness: eventType, router: router)
         handlerStore.registerHandler(handler)
      }

      return CommonFactory
         .viewModelBuilder
         .buildViewModel(of: PeerListViewModel.self)
   }

   private static func getUserInputHandler(
      witness _: PeerListUserInput.Type,
      router: some NavigationRouter<Peer.ID>
   ) -> some InputEventHandler<PeerListUserInput> { PeerListUserInputHandler(chatRouter: router) }
}
