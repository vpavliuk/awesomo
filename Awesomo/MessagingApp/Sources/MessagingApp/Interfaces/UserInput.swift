//
//  UserInput.swift
//
//
//  Created by Vova on 24.11.2023.
//

import Foundation
import Domain

struct UserInput<NetworkAddress: Hashable>: InputEvent {
   typealias PeerID = Peer<NetworkAddress>.ID
   var timestamp: Date

   let portID = "UserInput"

   enum Event: Hashable { case navigationPop }
   let event: Event
}
