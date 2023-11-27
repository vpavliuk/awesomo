//
//  PeerListUserInput.swift
//  
//
//  Created by Vova on 27.11.2023.
//

import Domain

enum PeerListUserInput<NetworkAddress: Hashable> {
   case didSelectPeer(Peer<NetworkAddress>.ID)
}
