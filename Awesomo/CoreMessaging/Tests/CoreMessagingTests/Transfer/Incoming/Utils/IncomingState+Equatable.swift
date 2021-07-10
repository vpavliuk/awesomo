//
//  IncomingState+Additions.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 07.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging

extension IncomingState: Equatable
      where InboxMessage: Equatable, InboxMessage.Payload: Equatable {

   public static func ==(lhs: IncomingState, rhs: IncomingState) -> Bool {
      return lhs.inbox == rhs.inbox
   }
}
