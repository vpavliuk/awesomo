//
//  PeerListViewModel.swift
//
//
//  Created by Vova on 26.11.2023.
//

import Domain
import Combine

final class PeerListViewModel<NetworkAddress: Hashable>: ViewModel<[Peer<NetworkAddress>.Snapshot], PeerListState<NetworkAddress>> {
   typealias UserInput = PeerListUserInput<NetworkAddress>

   var selectedPeerID: Peer<NetworkAddress>.ID? {
      didSet {
         guard let selectedPeerID else { return }
         userInputInternal.send(.didSelectPeer(selectedPeerID))
      }
   }

   // An outgoing stream of app events
   lazy var userInput: some Publisher<UserInput, Never> = userInputInternal
   private let userInputInternal: some Subject<UserInput, Never> = PassthroughSubject<UserInput, Never>()
}
