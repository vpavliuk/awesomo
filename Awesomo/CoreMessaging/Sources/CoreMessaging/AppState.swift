//
//  AppState.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 3/6/20.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

#warning("Rename to MainState or MasterState")
public final class AppState<
   ConcretePeer: Peer,
   ConcreteMessage: Message
>: ObservableObject {

   public convenience init(localPeerId: ConcretePeer.ID) {
      self.init(
         localPeerId: localPeerId,
         peersState: PeersState(),
         incomingState: IncomingState(),
         outgoingState: OutgoingState(senderId: localPeerId)
      )
   }

   internal init(
      localPeerId: ConcretePeer.ID,
      peersState: PeersState<ConcretePeer> = PeersState(),
      incomingState: IncomingState<ConcretePeer, ConcreteMessage> = IncomingState(),
      outgoingState: OutgoingState<ConcretePeer, ConcreteMessage>? = nil,
      selectedPeerId: ConcretePeer.ID? = nil
   ) {
      self.localPeerId = localPeerId
      self.peersState = peersState
      self.incomingState = incomingState
      self.outgoingState = outgoingState ?? OutgoingState(senderId: localPeerId)
      self.selectedPeerId = selectedPeerId
   }

   public let localPeerId: ConcretePeer.ID

   public var peersState: PeersState<ConcretePeer>

   public var incomingState: IncomingState<ConcretePeer, ConcreteMessage>
   public var outgoingState: OutgoingState<ConcretePeer, ConcreteMessage>

   #warning("Consider removing")
   @Published public var selectedPeerId: ConcretePeer.ID?
}
