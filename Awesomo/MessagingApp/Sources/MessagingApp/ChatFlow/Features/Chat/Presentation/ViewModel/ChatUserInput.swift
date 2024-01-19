//
//  ChatUserInput.swift
//
//
//  Created by Vova on 17.01.2024.
//

import Domain

enum ChatUserInput {
   case invite
   case sendMessage(MessageContent)
}

extension ChatUserInput: UserInput {

}


extension MessageContent: Codable {
   public func encode(to encoder: Encoder) throws {

   }
   
   public init(from decoder: Decoder) throws {
      self.init(contentID: ContentID(value: "Text"))
   }
}
