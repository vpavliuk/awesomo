//
//  ChatFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

import Domain

enum ChatFactory {

   #warning("Try to hide behind a protocol")
   static func getRouter() -> ChatRouter { ChatRouter() }

   static func getDestinationProvider(router: ChatRouter) -> ChatViewProvider {
      return ChatViewProvider(
         domainStore: CommonFactory.domainStore,
         userInputMerger: CommonFactory.userInputMerger,
         eventHandlerStore: CommonFactory.eventHandlerStore,
         navigationPopInputHandler: getNavigationPopInputHandler(router: router)
      )
   }

   private static func getNavigationPopInputHandler(router: ChatRouter) -> some InputEventHandler<ChatFlowNavigationPop> {
      return ChatFlowNavigationPopHandler(router: router)
   }

   static func getPeerListViewModel(router: some NavigationRouter<Peer.ID>) -> PeerListViewModel {
      return CommonFactory
         .viewModelBuilder
         .buildInteractiveViewModel(
            of: PeerListViewModel.self,
            userInputHandler: getPeerListUserInputHandler(router: router)
         )
   }

   private static func getPeerListUserInputHandler(router: some NavigationRouter<Peer.ID>) -> some InputEventHandler<PeerListUserInput> {
      return PeerListUserInputHandler(chatRouter: router)
   }
}
