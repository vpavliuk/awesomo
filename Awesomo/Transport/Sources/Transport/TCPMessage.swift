//
//  TCPMessage.swift
//
//
//  Created by Vova on 07.02.2024.
//

import Foundation
import Domain

enum TCPMessage: Codable {
   case invitation(sender: Peer.ID)
   case message(sender: Peer.ID, payload: Data)
}
