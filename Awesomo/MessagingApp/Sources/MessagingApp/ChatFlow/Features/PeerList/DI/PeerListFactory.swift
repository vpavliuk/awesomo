//
//  PeerListFactory.swift
//
//
//  Created by Vova on 18.01.2024.
//

import Domain

enum PeerListFactory {

   static func getViewModel(router: some NavigationRouter<Peer.ID>) -> PeerListViewModel {
      let handlerRegistry = CommonFactory.eventHandlerRegistry
      let eventType = PeerListUserInput.self

      if !handlerRegistry.isHandlerRegistered(for: eventType) {
         let handler = getUserInputHandler(witness: eventType, router: router)
         handlerRegistry.registerHandler(handler)
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
