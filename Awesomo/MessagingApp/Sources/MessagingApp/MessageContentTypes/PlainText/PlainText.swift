//
//  PlainText.swift
//  Messaging App
//
//  Created by Volodymyr Pavliuk on 23.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Domain

public struct PlainText {
   var text: String
}

extension PlainText: ChatMessageContent {
   public static let contentType: ChatMessageContentType = .plainText
}

extension ChatMessageContentType {
   static let plainText = Self("text/plain")
}
