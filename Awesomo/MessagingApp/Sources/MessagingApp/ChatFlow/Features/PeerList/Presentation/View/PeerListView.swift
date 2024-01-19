//
//  PeerListView.swift
//
//
//  Created by Vova on 26.11.2023.
//

import SwiftUI
import Combine
import Domain
import Utils

struct PeerListView: View {
   @EnvironmentObject
   var vm: PeerListViewModel

   var body: some View {
      switch vm.state {
      case .loading:
         ProgressView()
            .controlSize(.large)
      case .loadedEmpty:
         EmptyPeerList()
      case .loaded(let peers):
         LoadedPeerList(
            selection: $vm.selectedPeerID,
            peers: peers
         )
      }
   }
}

private struct EmptyPeerList: View {
   var body: some View {
      Text("Looks like no one's nearby")
         .font(.title)
         .multilineTextAlignment(.center)
   }
}

private struct LoadedPeerList: View {
   @EnvironmentObject
   var destinationProvider: ChatFlowViewProvider

   var selection: Binding<Peer.ID?>
   let peers: NonEmpty<PeerDisplayModel>

   var body: some View {
      List(peers, selection: selection) { peer in
         Text(peer.name)
      }
      .navigationDestination(for: Peer.ID.self) { peerID in
         destinationProvider.destinationView(for: peerID)
      }
   }
}

private struct PeerView: View {
   let peer: PeerDisplayModel
   var body: some View {
      Text(peer.name)
   }
}

// MARK: - Previews

#Preview("Loading") {
   PeerListView()
      .environmentObject(makeViewModel(state: .loadingSavedChats))
}

#Preview("Loaded one peer") {
   PeerListView()
      .environmentObject(
         makeViewModel(
            state: .loaded(
               [
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
      )
}

#Preview("Loaded two peers") {
   PeerListView()
      .environmentObject(
         makeViewModel(
            state: .loaded(
               [
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

      )
}

#Preview("Loaded empty") {
   PeerListView()
      .environmentObject(makeViewModel(state: .loaded([])))
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
