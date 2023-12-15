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
         guard let selectedPeerID else { return }
         userInputInternal.send(.didSelectPeer(selectedPeerID))
      }
   }

   // An outgoing stream of app events
   lazy var userInput: some Publisher<PeerListUserInput, Never> = userInputInternal
   private let userInputInternal: some Subject<PeerListUserInput, Never> = PassthroughSubject()
}
