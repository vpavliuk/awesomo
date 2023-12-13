//
//  StoredEvent.swift
//  Awesomo
//
//  Created by Vova on 13.12.2023.
//

import Foundation
import MessagingApp

struct StoredEvent: Codable {
   let eventTypeID: InputEventTypeID
   let eventData: Data
   let timeSincePrevious: TimeInterval
}

extension StoredEvent {
   init(appEvent: some InputEvent, timeSincePrevious: TimeInterval) {
      self.eventTypeID = type(of: appEvent).eventTypeID
      self.eventData = try! JSONEncoder().encode(appEvent)
      self.timeSincePrevious = timeSincePrevious
   }

   func decodeAppEvent() -> (any InputEvent)? {
      guard let appEventType = eventTypeID.eventType else {
         return nil
      }
      return try? JSONDecoder().decode(appEventType, from: eventData)
   }
}
