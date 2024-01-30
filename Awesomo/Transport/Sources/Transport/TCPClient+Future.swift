//
//  TCPClient+Future.swift
//
//
//  Created by Vova on 30.01.2024.
//

import Foundation
import Domain
import Combine

extension TCPClient {

   func upload(_ data: Data, for peer: Peer.Snapshot) -> Future<TransportProcessor.Output, Never> {
      Future {
         do {
            try await upload(data, to: peer.networkAddress.value)
            return .invitationForPeerWasSentOverNetwork(peer.peerID)
         } catch {
            return .failedToSendInvitationOverNetwork(peer.peerID)
         }
      }
   }

}
