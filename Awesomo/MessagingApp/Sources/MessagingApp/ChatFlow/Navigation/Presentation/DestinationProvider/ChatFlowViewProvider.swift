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

   init(userInputMerger: UserInputMergerProtocol) {
      userInputMerger.merge(publisher: userInput)
   }

   func destinationView(for destinationObject: Peer.ID) -> some View {
      #warning("Work out back title")
      return ChatScreen()
         .customBackButton(title: "Peers") { [weak self] in
            self?.userInput.send(ChatFlowNavigationPop())
         }
         .environmentObject(ChatFactory.getViewModel(peerID: destinationObject))
   }

   // An outgoing stream of app events
   private let userInput: some Subject<ChatFlowNavigationPop, Never> = PassthroughSubject()
}
