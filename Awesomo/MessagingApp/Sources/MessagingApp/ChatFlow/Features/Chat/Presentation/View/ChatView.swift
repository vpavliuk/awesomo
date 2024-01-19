//
//  ChatView.swift
//
//
//  Created by Vova on 20.12.2023.
//

import SwiftUI
import Combine
import Domain

struct ChatView: View {
   @EnvironmentObject
   var vm: ChatViewModel

   var body: some View {
      switch vm.state {
      case .loading:
         ProgressView()
            .controlSize(.large)
      case .strangerPeer(let peer):
         StrangerPeerChatView(inviteText: peer.inviteButtonTitle) {
            vm.userInput.send(.invite)
         }
      case .friend(_):
         StrangerPeerChatView(inviteText: "") {}
      case .peerInvitedUs:
         StrangerPeerChatView(inviteText: "") {}
      case .peerWasInvited:
         StrangerPeerChatView(inviteText: "") {}
      }
   }
}

private struct StrangerPeerChatView: View {
   let inviteText: String
   let onInvite: () -> Void

   var body: some View {
      Button(action: onInvite) {
         Text(inviteText)
      }
   }
}

#Preview {
   ChatView()
      .environmentObject(
         ChatViewModel(
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
            userInputMerger: UserInputMerger(userInputSink: PassthroughSubject()),
            eventHandlerStore: EventHandlerStore(),
            userInputHandler: ChatUserInputHandler(coreMessenger: CoreMessenger())
         )
      )
}
