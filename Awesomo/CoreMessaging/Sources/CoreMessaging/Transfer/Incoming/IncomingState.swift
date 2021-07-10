//
//  IncomingState.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 07.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public final class IncomingState<
   ConcretePeer: Peer,
   InboxMessage: Message
>: ObservableObject {

   public typealias Inbox = [ConcretePeer.ID: Set<InboxMessage>]

   internal init(inbox: Inbox = [:]) {
      self.inbox = inbox
   }

   #warning("There should not be a direct write access to inbox from outside the module")
   @Published public var inbox: Inbox
}
