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
   static func fromDomainState(_ domainState: CoreMessenger.State) -> Self {
      switch domainState {
      case .loadingSavedChats:
         return .loading
      case .loaded(let peers):
         let peerDisplayModels = peers.map(PeerDisplayModel.init)
         if let nonEmpty = NonEmpty(peerDisplayModels) {
            return .loaded(nonEmpty)
         } else {
            return .loadedEmpty
         }
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
