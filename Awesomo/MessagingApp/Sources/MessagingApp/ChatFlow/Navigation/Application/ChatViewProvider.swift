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

   func destinationView(for destinationObject: Peer.ID) -> some View {
      switch domainSource.value {
      case .loaded(let peers):
         if let peer = peers.first(where: { $0.peerID == destinationObject }) {
            #warning("Extract view composition")
            return ChatView(peerName: peer.name)
               .navigationBarBackButtonHidden(true)
               .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                     Button { [weak self] in
                        self?.userInput.send(ChatFlowNavigationPop())
                     } label: {
                        HStack {
                           Image(systemName: "chevron.backward")
                           Text("Custom Back")
                        }
                     }
                  }
               }
         }
      default:
         assertionFailure("Could not find the peer by id")
      }
      return ChatView(peerName: "Julia").navigationBarBackButtonHidden(true)
         .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Button { [weak self] in
                  self?.userInput.send(ChatFlowNavigationPop())
               } label: {
                  HStack {
                     Image(systemName: "chevron.backward")
                     Text("Custom Back")
                  }
               }
            }
         }
   }

   // An outgoing stream of app events
   private let userInput: some Subject<ChatFlowNavigationPop, Never> = PassthroughSubject()
}
