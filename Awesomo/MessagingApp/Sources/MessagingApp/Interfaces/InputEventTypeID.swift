//
//  InputEventTypeID.swift
//
//
//  Created by Vova on 13.12.2023.
//

public struct InputEventTypeID: Hashable, Codable {
   init(value: String) {
      self.value = value
   }
   private let value: String
}

extension InputEventTypeID {

   public func getConcreteEventType() -> InputEvent.Type? { Self.eventTypesByID[self] }

   private static var eventTypesByID: [Self: InputEvent.Type] =
         Dictionary(uniqueKeysWithValues: eventTypes.map { ($0.eventTypeID, $0) })

   private static let eventTypes: [any InputEvent.Type] = [
      PeerAvailabilityEvent.self,
      PeerListUserInput.self,
      CommonInput.self,
   ]
}
