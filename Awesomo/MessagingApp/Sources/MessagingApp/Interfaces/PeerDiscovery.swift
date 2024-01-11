//
//  PeerDiscovery.swift
//  MessagingApp
//
//  Created by Vova on 10.11.2023.
//

import Domain

public enum PeerAvailabilityEvent: InputEvent, Hashable {
   case peersDidAppear([Peer.ID: PeerEmergence])
   case peersDidDisappear(Set<Peer.ID>)
}
