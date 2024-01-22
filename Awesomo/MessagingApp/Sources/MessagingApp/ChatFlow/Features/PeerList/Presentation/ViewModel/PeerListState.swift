//
//  PeerListState.swift
//  
//
//  Created by Vova on 26.11.2023.
//

import Domain
import Utils

enum PeerListState {
   case loading
   case loadedEmpty(title: String, description: String)
   case loaded(NonEmpty<PeerDisplayModel>)
}

extension PeerListState: DomainDerivable {
   static func fromDomainState(_ domainState: CoreMessenger.State) -> Self {
      let peerDisplayModels = domainState.map(PeerDisplayModel.init)
      if let nonEmpty = NonEmpty(peerDisplayModels) {
         return .loaded(nonEmpty)
      } else {
         return .loadedEmpty(
            title: "No one's nearby :-(",
            description: "Make sure that the two devices are connected to the same WiFi network."
         )
      }
   }
}

struct PeerDisplayModel: Hashable, Identifiable {
   let id: Peer.ID
   let name: String
}

extension PeerDisplayModel {
   init(peer: Peer.Snapshot) {
      id = peer.peerID
      name = peer.name
   }
}
