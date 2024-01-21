//
//  ChatScreen.swift
//
//
//  Created by Vova on 20.12.2023.
//

import SwiftUI
import Combine
import Domain

struct ChatScreen: View {
   @EnvironmentObject
   var vm: InteractiveViewModel<Peer.Snapshot?, ChatState, ChatUserInput>

   var body: some View {
      switch vm.state {
      case .loading:
         ProgressView()
            .controlSize(.large)

      case .strangerPeer(let peerID, let displayModel):
         StrangerPeerChatView(displayModel) {
            vm.userInput.send(.didInvitePeer(peerID))
         }

      case .friend(_):
         StrangerPeerChatView(StrangerPeerDisplayModel(inviteButtonTitle: "")) {}

      case .peerInvitedUs(let peerID, let displayModel):
         PeerInvitedUsChatView(displayModel) {
            vm.userInput.send(.didAcceptInvitation(peerID))
         } onDeclineTapped: {
            vm.userInput.send(.didDeclineInvitation(peerID))
         }

      case .peerWasInvited:
         StrangerPeerChatView(StrangerPeerDisplayModel(inviteButtonTitle: "")) {}

      case .missingPeer(let text):
         MissingPeerChatView(text: text)
      }
   }
}

// MARK: - Previews

#Preview {
   ChatScreen()
      .environmentObject(
         InteractiveViewModel<Peer.Snapshot?, ChatState, ChatUserInput>(
            initialState: Peer.Snapshot(
               peerID: Peer.ID(value: ""),
               status: .online,
               relation: .stranger,
               name: "Po",
               networkAddress: NetworkAddress(value: ""),
               incomingMessages: [],
               outgoingMessages: []
            ),
            domainSource: PassthroughSubject(),
            userInputMerger: UserInputMerger(userInputSink: PassthroughSubject())
         )
      )
}
