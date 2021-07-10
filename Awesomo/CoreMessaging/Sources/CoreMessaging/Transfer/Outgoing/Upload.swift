//
//  Upload.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 3/26/20.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

public struct Upload<
   User: Peer,
   OutboxMessage: Message
>: Identifiable {

   public let id = UUID()
   public let receiver: User
   public let networkMessage: NetworkMessage<User, OutboxMessage.Payload>
   internal let domainMessageId: OutboxMessage.ID
}
