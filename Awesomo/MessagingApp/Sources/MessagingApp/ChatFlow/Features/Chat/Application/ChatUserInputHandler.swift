//
//  ChatUserInputHandler.swift
//
//
//  Created by Vova on 19.01.2024.
//

import Domain

struct ChatUserInputHandler: InputEventHandler {
   init(coreMessenger: CoreMessenger) {
      self.coreMessenger = coreMessenger
   }

   func on(_ event: ChatUserInput) {

   }

   private let coreMessenger: CoreMessenger
}
