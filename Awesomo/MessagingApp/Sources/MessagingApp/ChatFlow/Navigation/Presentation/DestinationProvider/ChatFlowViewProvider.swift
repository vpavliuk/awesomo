//
//  ChatFlowViewProvider.swift
//
//
//  Created by Vova on 11.01.2024.
//

import Domain
import Combine
import SwiftUI

final class ChatFlowViewProvider: ObservableObject {

   init(
      domainStore: DomainStore<CoreMessenger.State>,
      userInputMerger: UserInputMergerProtocol,
      eventHandlerStore: EventHandlerStoreProtocol,
      navigationPopInputHandler: some InputEventHandler<ChatFlowNavigationPop>
   ) {
      self.domainStore = domainStore
      self.eventHandlerStore = eventHandlerStore

      userInputMerger.merge(publisher: userInput)
      #warning("Handle error")
      try! eventHandlerStore.registerHandler(navigationPopInputHandler)
   }

   deinit {
      #warning("Handle error")
      try! eventHandlerStore.unregisterHandler(for: ChatFlowNavigationPop.self)
   }

   private let domainStore: DomainStore<CoreMessenger.State>

   private var peers: [Peer.Snapshot] {
      if case .loaded(let peers) = domainStore.state {
         return peers
      }

      return []
   }

   func destinationView(for destinationObject: Peer.ID) -> some View {
      guard let peer = peers.first(where: { $0.peerID == destinationObject }) else {
         assertionFailure("Could not find the peer by id")
         return chatView(title: "", peerID: destinationObject)
      }

      return chatView(title: peer.name, peerID: destinationObject)
   }

   private func chatView(title: String, peerID: Peer.ID) -> some View {
      #warning("Work out back title")
      return ChatView()
         .customBackButton(title: "Peers") { [weak self] in
            self?.userInput.send(ChatFlowNavigationPop())
         }
         .environmentObject(ChatFactory.getViewModel(peerID: peerID))
   }

   // An outgoing stream of app events
   private let userInput: some Subject<ChatFlowNavigationPop, Never> = PassthroughSubject()

   private let eventHandlerStore: EventHandlerStoreProtocol
}
