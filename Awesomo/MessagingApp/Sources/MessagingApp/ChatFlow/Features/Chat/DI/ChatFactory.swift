//
//  ChatFactory.swift
//
//
//  Created by Vova on 18.01.2024.
//

import Domain

enum ChatFactory {

   static func getViewModel(peerID: Peer.ID) -> InteractiveViewModel<Peer.Snapshot?, ChatState, ChatUserInput> {
      let handlerStore = CommonFactory.eventHandlerStore
      let eventType = ChatUserInput.self

      if !handlerStore.isHandlerRegistered(for: eventType) {
         let handler = getUserInputHandler(witness: eventType)
         handlerStore.registerHandler(handler)
      }

      return CommonFactory
         .viewModelBuilder
         .buildViewModel(of: InteractiveViewModel.self) { peers in peers.first { $0.peerID == peerID } }
   }

   private static func getUserInputHandler(witness _: ChatUserInput.Type) -> some InputEventHandler<ChatUserInput> {
      return ChatUserInputHandler(
         coreMessenger: CommonFactory.coreMessenger,
         domainStore: CommonFactory.domainStore
      )
   }
}
