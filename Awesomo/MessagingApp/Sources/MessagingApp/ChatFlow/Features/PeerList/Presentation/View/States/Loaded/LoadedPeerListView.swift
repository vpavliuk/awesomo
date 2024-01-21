//
//  LoadedPeerListView.swift
//
//
//  Created by Vova on 21.01.2024.
//

import SwiftUI
import Domain
import Utils

struct LoadedPeerListView: View {
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
