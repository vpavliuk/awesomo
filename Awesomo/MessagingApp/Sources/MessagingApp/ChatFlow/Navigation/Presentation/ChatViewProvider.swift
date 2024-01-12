//
//  ChatViewProvider.swift
//
//
//  Created by Vova on 11.01.2024.
//

import Domain
import Combine
import SwiftUI

final class ChatViewProvider: ObservableObject {

   init(domainSource: CurrentValueSubject<CoreMessenger.State, Never>, userInputMerger: UserInputMergerProtocol) {
      self.domainSource = domainSource
      userInputMerger.merge(publisher: userInput)
   }

   private let domainSource: CurrentValueSubject<CoreMessenger.State, Never>

   private var peers: [Peer.Snapshot] {
      if case .loaded(let peers) = domainSource.value {
         return peers
      }

      return []
   }

   func destinationView(for destinationObject: Peer.ID) -> some View {
      guard let peer = peers.first(where: { $0.peerID == destinationObject }) else {
         assertionFailure("Could not find the peer by id")
         return chatView(title: "")
      }

      return chatView(title: peer.name)
   }

   private func chatView(title: String) -> some View {
      #warning("Work out back title")
      return ChatView(peerName: title)
         .customBackButton(title: "Peers") { [weak self] in
            self?.userInput.send(ChatFlowNavigationPop())
         }
   }

   // An outgoing stream of app events
   private let userInput: some Subject<ChatFlowNavigationPop, Never> = PassthroughSubject()
}
