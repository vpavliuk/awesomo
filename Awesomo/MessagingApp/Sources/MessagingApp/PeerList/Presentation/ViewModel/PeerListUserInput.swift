//
//  PeerListUserInput.swift
//  
//
//  Created by Vova on 27.11.2023.
//

import Domain

enum PeerListUserInput: InputEvent {
   case didSelectPeer(Peer.ID)
}


struct PeerListUserInputHandler: InputHandler {
   func on(_ event: PeerListUserInput) {

   }
}
