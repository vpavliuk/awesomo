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

   static func getDestinationProvider(router: some NavigationRouter<Peer.ID>) -> ChatFlowViewProvider {
      return ChatFlowViewProvider(
         domainStore: CommonFactory.domainStore,
         userInputMerger: CommonFactory.userInputMerger,
         eventHandlerStore: CommonFactory.eventHandlerStore,
         navigationPopInputHandler: getNavigationPopInputHandler(router: router)
      )
   }

   private static func getNavigationPopInputHandler(router: some NavigationRouter<Peer.ID>)
         -> some InputEventHandler<ChatFlowNavigationPop> { ChatFlowNavigationPopHandler(router: router) }
}
