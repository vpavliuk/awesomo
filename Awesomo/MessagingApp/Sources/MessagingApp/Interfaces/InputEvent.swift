//
//  InputEvent.swift
//  MessagingApp
//
//  Created by Vova on 10.11.2023.
//

public protocol InputEvent: Codable {
   static var eventTypeID: InputEventTypeID { get }
}

extension InputEvent {
   public static var eventTypeID: InputEventTypeID { InputEventTypeID(Self.self) }
}

public enum CommonInput: InputEvent {
   case initial
}

import Domain

struct CommonInputHandler: InputHandler {
   init(coreMessenger: CoreMessenger) {
      self.coreMessenger = coreMessenger
   }
   func on(_ event: CommonInput) -> CoreMessenger.State {
      print("Common input detected: \(event)")
      return coreMessenger.add(.initial)
   }
   private let coreMessenger: CoreMessenger
}
