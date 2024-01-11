//
//  PeerListViewModel.swift
//
//
//  Created by Vova on 26.11.2023.
//

import Domain
import Combine

final class PeerListViewModel: ViewModel<CoreMessenger.State, PeerListState> {

   required init(
      domainSource: CurrentValueSubject<CoreMessenger.State, Never>,
      userInputMerger: UserInputMergerProtocol
   ) {
      super.init(domainSource: domainSource, userInputMerger: userInputMerger)
      userInputMerger.merge(publisher: userInput)
   }

   var selectedPeerID: Peer.ID? {
      didSet {
         guard let selectedPeerID else {
            assertionFailure("Unexpectedly received nil as selected peer id")
            return
         }
         userInput.send(.didSelectPeer(selectedPeerID))
      }
   }

   // An outgoing stream of app events
   private let userInput: some Subject<PeerListUserInput, Never> = PassthroughSubject()
}
