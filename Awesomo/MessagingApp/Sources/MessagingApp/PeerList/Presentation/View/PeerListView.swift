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
   @ObservedObject
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

   var selection: Binding<Peer.ID?>
   let peers: NonEmpty<PeerDisplayModel>
   var body: some View {
      List(peers) { peer in
         Text(peer.name)
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
   PeerListView(
      vm: PeerListViewModel(
         domainSource: CurrentValueSubject(.loadingSavedChats)
      )
   )
}

#Preview("Loaded one peer") {
   PeerListView(
      vm: PeerListViewModel(
         domainSource: CurrentValueSubject(.loaded([
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
      )
}

#Preview("Loaded two peers") {
   PeerListView(
      vm: PeerListViewModel(
         domainSource: CurrentValueSubject(.loaded([
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
      )
}

#Preview("Loaded empty") {
   PeerListView(
      vm: PeerListViewModel(
         domainSource: CurrentValueSubject(.loaded([]))
      )
   )
}
