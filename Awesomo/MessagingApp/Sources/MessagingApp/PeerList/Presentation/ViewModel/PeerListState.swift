//
//  PeerListState.swift
//  
//
//  Created by Vova on 26.11.2023.
//

import Domain
import Utils

enum PeerListState<NetworkAddress: Hashable> {
   typealias DisplayModel = PeerDisplayModel<NetworkAddress>
   case loading
   case loadedEmpty
   case loaded(NonEmpty<DisplayModel>)
}

extension PeerListState: DomainDerivable {
   init(domainState: [Peer<NetworkAddress>.Snapshot]) {
      let peerDisplayModels = domainState.map(PeerDisplayModel.init)
      if let nonEmpty = NonEmpty(peerDisplayModels) {
         self = .loaded(nonEmpty)
      } else {
         self = .loadedEmpty
      }
   }
   static var defaultValue: Self { .loading }
}

struct PeerDisplayModel<NetworkAddress: Hashable>: Hashable, Identifiable {
   let id: Peer<NetworkAddress>.ID
   let name: String
}

extension PeerDisplayModel {
   init(peer: Peer<NetworkAddress>.Snapshot) {
      id = peer.peerID
      name = peer.name
   }
}
