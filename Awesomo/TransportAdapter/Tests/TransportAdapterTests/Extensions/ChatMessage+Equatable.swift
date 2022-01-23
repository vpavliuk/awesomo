//
//  ChatMessage+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 03.11.2021.
//

import Domain

extension ChatMessage: Equatable {
   public static func == (_: ChatMessage, _: ChatMessage) -> Bool { false }
}
