//
//  IncomingChatMessage.swift
//  Domain
//
//  Created by Vova on 12.11.2023.
//

import Foundation

public struct IncomingChatMessage: Hashable {
   public let timestamp: Date
   public let content: MessageContent
}
