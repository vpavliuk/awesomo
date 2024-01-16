//
//  ChatFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

enum ChatFactory {

   #warning("Try to hide behind a protocol")
   static let router = ChatRouter()

   static let peerListUserInputHandler = PeerListUserInputHandler(chatRouter: router)

   static func getDestinationProvider() -> ChatViewProvider {
      return ChatViewProvider(
         domainStore: CommonFactory.domainStore,
         userInputMerger: CommonFactory.userInputMerger,
         eventHandlerStore: CommonFactory.eventHandlerStore,
         navigationPopInputHandler: navigationPopInputHandler
      )
   }

   static let navigationPopInputHandler: some InputEventHandler<ChatFlowNavigationPop>
         = ChatFlowNavigationPopHandler(router: router)
}
