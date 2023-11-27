//
//  PeerListView.swift
//
//
//  Created by Vova on 26.11.2023.
//

import SwiftUI
import Domain
import Utils

struct PeerListView<NetworkAddress: Hashable>: View {
   @ObservedObject
   var vm: PeerListViewModel<NetworkAddress>

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

private struct LoadedPeerList<NetworkAddress: Hashable>: View {
   typealias DisplayModel = PeerDisplayModel<NetworkAddress>

   var selection: Binding<Peer<NetworkAddress>.ID?>
   let peers: NonEmpty<DisplayModel>
   var body: some View {
      List(peers) { peer in
         Text(peer.name)
      }
   }
}

private struct PeerView<NetworkAddress: Hashable>: View {
   let peer: PeerDisplayModel<NetworkAddress>
   var body: some View {
      Text(peer.name)
   }
}

// MARK: - Previews

#Preview("Loading") {
   PeerListView<Int>(
      vm: PeerListViewModel(initialDomainState: nil)
   )
}

#Preview("Loaded one peer") {
   PeerListView(
      vm: PeerListViewModel(
         initialDomainState: [
            Peer<Int>.Snapshot(
               peerID: EntityID(value: "1"),
               status: .online,
               relation: .friend,
               name: "John",
               networkAddress: 123,
               incomingMessages: [],
               outgoingMessages: []
            )
         ]
      )
   )
}

#Preview("Loaded two peers") {
   PeerListView(
      vm: PeerListViewModel(
         initialDomainState: [
            Peer<Int>.Snapshot(
               peerID: EntityID(value: "1"),
               status: .online,
               relation: .friend,
               name: "John",
               networkAddress: 123,
               incomingMessages: [],
               outgoingMessages: []
            ),
            Peer<Int>.Snapshot(
               peerID: EntityID(value: "2"),
               status: .online,
               relation: .friend,
               name: "Mary",
               networkAddress: 123,
               incomingMessages: [],
               outgoingMessages: []
            )
         ]
      )
   )
}

#Preview("Loaded empty") {
   PeerListView<Int>(
      vm: PeerListViewModel(initialDomainState: [])
   )
}
