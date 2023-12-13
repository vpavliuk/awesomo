//
//  PeerListViewModel.swift
//
//
//  Created by Vova on 26.11.2023.
//

import Domain
import Combine

final class PeerListViewModel: ViewModel<CoreMessenger.State, PeerListState> {

   var selectedPeerID: Peer.ID? {
      didSet {
         guard let selectedPeerID else { return }
         userInputInternal.send(.didSelectPeer(selectedPeerID))
      }
   }

   // An outgoing stream of app events
   lazy var userInput: some Publisher<PeerListUserInput, Never> = userInputInternal
   private let userInputInternal: some Subject<PeerListUserInput, Never> = PassthroughSubject()
}
