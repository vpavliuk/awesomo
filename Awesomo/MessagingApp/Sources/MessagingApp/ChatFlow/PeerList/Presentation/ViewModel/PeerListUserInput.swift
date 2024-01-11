//
//  PeerListUserInput.swift
//  
//
//  Created by Vova on 27.11.2023.
//

import Domain

enum PeerListUserInput: UserInput {
   case didSelectPeer(Peer.ID)
}
