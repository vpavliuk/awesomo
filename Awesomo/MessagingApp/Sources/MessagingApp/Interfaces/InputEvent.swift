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


#warning("Consider removing CommonInput")
public enum CommonInput: InputEvent {
   case initial
}

import Domain

struct CommonInputHandler: InputHandler {
   init(coreMessenger: CoreMessenger, domainStore: DomainStore<CoreMessenger.State>) {
      self.coreMessenger = coreMessenger
      self.domainStore = domainStore
   }

   func on(_ event: CommonInput) {
      print("Common input detected: \(event)")
      domainStore.state = coreMessenger.add(.initial)
   }

   private let coreMessenger: CoreMessenger
   private let domainStore: DomainStore<CoreMessenger.State>
}
