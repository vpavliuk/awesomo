//
//  ChatView.swift
//
//
//  Created by Vova on 20.12.2023.
//

import SwiftUI
import Domain

struct ChatView: View {
   @EnvironmentObject
   var vm: InteractiveViewModel<Peer.Snapshot, ChatState, ChatUserInput>

   var body: some View {
      switch vm.state {
      case .loading:
         ProgressView()
            .controlSize(.large)
      case .strangerPeer:
         StrangerPeerChatView()
      case .friend(_):
         StrangerPeerChatView()
      case .peerInvitedUs:
         StrangerPeerChatView()
      case .peerWasInvited:
         StrangerPeerChatView()
      }
   }
}

private struct StrangerPeerChatView: View {
   @EnvironmentObject
   var vm: ChatViewModel

   var body: some View {
      Button {
         vm.userInput.send(.invite)
      } label: {
         Text("Invite")
      }
   }
}

#Preview {
   ChatView()
}
