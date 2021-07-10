//
//  Upload+Additions.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 20.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

@testable import CoreMessaging

extension Upload where User == TestPeer {
   init(receiver: TestPeer, domainMessage: OutboxMessage)  {
      let networkMessage = NetworkMessage<User, OutboxMessage.Payload>(
         sender: TestPeer(id: "sender").id,
         payload: domainMessage.payload
      )
      self.init(
         receiver: receiver,
         networkMessage: networkMessage,
         domainMessageId: domainMessage.id
      )
   }
}
