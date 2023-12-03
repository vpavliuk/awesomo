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
   case loadedEmpty
   case loaded(NonEmpty<PeerDisplayModel>)
}

extension PeerListState: DomainDerivable {
   init(domainState: [Peer.Snapshot]) {
      let peerDisplayModels = domainState.map(PeerDisplayModel.init)
      if let nonEmpty = NonEmpty(peerDisplayModels) {
         self = .loaded(nonEmpty)
      } else {
         self = .loadedEmpty
      }
   }
   static var defaultValue: Self { .loading }
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
