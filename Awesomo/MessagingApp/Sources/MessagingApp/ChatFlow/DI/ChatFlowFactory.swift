//
//  ChatFlowFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

import Domain

enum ChatFlowFactory {

   #warning("Try to hide behind a protocol")
   static func getRouter() -> ChatRouter { ChatRouter() }

   #warning("Try to hide behind a protocol")
   static func getDestinationProvider(router: some NavigationRouter<Peer.ID>) -> ChatFlowViewProvider {

      let handlerStore = CommonFactory.eventHandlerStore
      let eventType = ChatFlowNavigationPop.self

      if !handlerStore.isHandlerRegistered(for: eventType) {
         let handler = getNavigationPopInputHandler(witness: eventType, router: router)
         handlerStore.registerHandler(handler)
      }

      return ChatFlowViewProvider(
         domainStore: CommonFactory.domainStore,
         userInputMerger: CommonFactory.userInputMerger
      )
   }

   private static func getNavigationPopInputHandler(
      witness _: ChatFlowNavigationPop.Type,
      router: some NavigationRouter<Peer.ID>
   ) -> some InputEventHandler<ChatFlowNavigationPop> { ChatFlowNavigationPopHandler(router: router) }
}
