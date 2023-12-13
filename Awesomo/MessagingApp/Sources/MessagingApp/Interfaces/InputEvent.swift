//
//  InputEvent.swift
//  MessagingApp
//
//  Created by Vova on 10.11.2023.
//

public protocol InputEvent: Codable {
   static var eventTypeID: InputEventTypeID { get }
}

public enum CommonInput: InputEvent {
   public static let eventTypeID = InputEventTypeID(value: "CommonInput")
   case initial
}

struct CommonInputHandler: InputHandler {
   func on(_ event: CommonInput) {
      print("Common input detected: \(event)")
   }
}
