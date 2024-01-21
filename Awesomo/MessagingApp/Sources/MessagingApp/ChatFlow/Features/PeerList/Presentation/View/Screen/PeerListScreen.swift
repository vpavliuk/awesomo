//
//  PeerListScreen.swift
//
//
//  Created by Vova on 26.11.2023.
//

import SwiftUI
import Combine
import Domain
import Utils

struct PeerListScreen: View {
   @EnvironmentObject
   var vm: PeerListViewModel

   var body: some View {
      switch vm.state {
      case .loading:
         LoadingPeerListView()
      case .loadedEmpty(let title, let description):
         EmptyPeerListView(
            messageTitle: title,
            messageDescription: description
         )
      case .loaded(let peers):
         LoadedPeerListView(
            selection: $vm.selectedPeerID,
            peers: peers
         )
      }
   }
}

// MARK: - Previews

#Preview("Loaded one peer") {
   PeerListScreen()
      .environmentObject(
         makeViewModel(
            state: [
               Peer.Snapshot(
                  peerID: EntityID(value: "1"),
                  status: .online,
                  relation: .friend,
                  name: "John",
                  networkAddress: NetworkAddress(value: "123"),
                  incomingMessages: [],
                  outgoingMessages: []
               )
            ]
         )
      )
}

#Preview("Loaded two peers") {
   PeerListScreen()
      .environmentObject(
         makeViewModel(
            state: [
               Peer.Snapshot(
                  peerID: EntityID(value: "1"),
                  status: .online,
                  relation: .friend,
                  name: "John",
                  networkAddress: NetworkAddress(value: "123"),
                  incomingMessages: [],
                  outgoingMessages: []
               ),
               Peer.Snapshot(
                  peerID: EntityID(value: "2"),
                  status: .online,
                  relation: .friend,
                  name: "Alice",
                  networkAddress: NetworkAddress(value: "123"),
                  incomingMessages: [],
                  outgoingMessages: []
               )
            ]
         )
      )
}

#Preview("Loaded empty") {
   PeerListScreen()
      .environmentObject(makeViewModel(state: []))
}

private func makeViewModel(state: CoreMessenger.State) -> PeerListViewModel {
   PeerListViewModel(
      initialState: state,
      domainSource: PassthroughSubject(),
      userInputMerger: UserInputMerger(
         userInputSink: PassthroughSubject()
      )
   )
}

private class PreviewInputHandler: InputEventHandler {
   func on(_ event: PeerListUserInput) {}
}
