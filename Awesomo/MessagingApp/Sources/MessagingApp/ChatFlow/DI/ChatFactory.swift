//
//  ChatFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

enum ChatFactory {

   #warning("Try to hide behind a protocol")
   static let router = ChatRouter()

   static let peerListUserInputHandler = PeerListUserInputHandler(
      coreMessenger: CommonFactory.coreMessenger,
      chatRouter: router
   )

   static let destinationProvider = ChatViewProvider(
      domainSource: CommonFactory.domainPublisher,
      userInputMerger: CommonFactory.userInputMerger,
      eventHandlerStore: CommonFactory.eventHandlerStore
   )

   static let navigationPopInputHandler: some InputHandler<ChatFlowNavigationPop> = ChatFlowNavigationPopHandler(
      coreMessenger: CommonFactory.coreMessenger,
      router: router
   )
}
