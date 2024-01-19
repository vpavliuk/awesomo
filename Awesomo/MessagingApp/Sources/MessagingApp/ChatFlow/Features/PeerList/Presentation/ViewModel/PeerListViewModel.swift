//
//  PeerListViewModel.swift
//
//
//  Created by Vova on 26.11.2023.
//

import Domain
import Combine

final class PeerListViewModel: InteractiveViewModel<CoreMessenger.State, PeerListState, PeerListUserInput> {

   var selectedPeerID: Peer.ID? {
      didSet {
         guard let selectedPeerID else {
            return
         }
         userInput.send(.didSelectPeer(selectedPeerID))
      }
   }
}
