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
            assertionFailure("Unexpectedly received nil as selected peer id")
            return
         }
         userInput.send(.didSelectPeer(selectedPeerID))
      }
   }
}
