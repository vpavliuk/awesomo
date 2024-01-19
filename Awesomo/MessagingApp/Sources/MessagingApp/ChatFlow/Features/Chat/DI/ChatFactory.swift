//
//  ChatFactory.swift
//
//
//  Created by Vova on 18.01.2024.
//

import Domain

enum ChatFactory {

   static func getViewModel(peerID: Peer.ID) -> ChatViewModel {
      return CommonFactory
         .viewModelBuilder
         .buildInteractiveViewModel(
            of: ChatViewModel.self,
            userInputHandler: getUserInputHandler()
         ) { (biggerState: CoreMessenger.State) in
            var peers: [Peer.Snapshot] = []
            if case .loaded(let loadedPeers) = biggerState {
               peers = loadedPeers
            }
            #warning("Get rid of force unwrap")
            return peers.first { $0.peerID == peerID }!
         }
   }

   private static func getUserInputHandler()
         -> some InputEventHandler<ChatUserInput> { ChatUserInputHandler(coreMessenger: CommonFactory.coreMessenger) }
}
