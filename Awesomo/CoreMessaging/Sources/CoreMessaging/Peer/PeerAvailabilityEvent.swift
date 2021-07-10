//
//  PeerAvailabilityEvent.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 22.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

struct PeerAvailabilityEvent<ConcretePeer: Peer>: AvailabilityEvent {
   var type: AvailabilityEventType
   var object: ConcretePeer
}
