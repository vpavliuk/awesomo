//
//  OutgoingState+Additions.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 02.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

@testable import CoreMessaging

extension OutgoingState where User == TestPeer {

   convenience init() {
      self.init(senderId: "localId")
   }

   func copyWith(
      senderId: User.ID? = nil,
      outbox: [User.ID: Set<OutboxMessage>]? = nil,
      sent: [User.ID: Set<OutboxMessage>]? = nil
   ) -> Self {
      return Self(
         senderId: senderId ?? self.senderId,
         outbox: outbox ?? self.outbox,
         sent: sent ?? self.sent
      )
   }
}

extension OutgoingState {
   func getUpload(for message: OutboxMessage) -> Upload<User, OutboxMessage>? {
      let filtered = pendingUploads.filter{$0.domainMessageId == message.id}
      assert(filtered.count <= 1)
      return filtered.first
   }
}

extension OutgoingState: Equatable {
   public static func ==(lhs: OutgoingState, rhs: OutgoingState) -> Bool {
      return lhs.senderId == rhs.senderId
            && lhs.outbox == rhs.outbox
            && lhs.sent == rhs.sent
   }
}
