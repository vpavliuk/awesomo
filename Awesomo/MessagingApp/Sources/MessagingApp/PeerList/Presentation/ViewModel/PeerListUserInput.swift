//
//  PeerListUserInput.swift
//  
//
//  Created by Vova on 27.11.2023.
//

import Domain

public enum PeerListUserInput: InputEvent {
   static public let eventTypeID = InputEventTypeID(value: "PeerListUserInput")
   case didSelectPeer(Peer.ID)
}
