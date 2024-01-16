//
//  EventHandlerStore.swift
//
//
//  Created by Vova on 14.01.2024.
//

protocol EventHandlerStoreProtocol: AnyObject {

   func registerHandler(_ handler: some InputEventHandler) throws

   func unregisterHandler<E: InputEvent>(for _: E.Type) throws

   func getHandler(for _: some InputEvent) -> (any InputEventHandler)?
}

final class EventHandlerStore: EventHandlerStoreProtocol {

   private func hasHandler<E: InputEvent>(for _: E.Type) -> Bool {
      handlers.keys.contains(E.eventTypeID)
   }

   func registerHandler<E: InputEvent>(_ handler: some InputEventHandler<E>) throws {
      guard !hasHandler(for: E.self) else {
         throw AppError.cannotRegisterAnotherHandlerForSameEventType(E.eventTypeID, handler)
      }

      handlers[E.eventTypeID] = handler
   }

   func unregisterHandler<E: InputEvent>(for _: E.Type) throws {
      guard hasHandler(for: E.self) else {
         return
         //throw AppError.cannotRegisterAnotherHandlerForSameEventType(eventTypeID, handler)
      }

      handlers[E.eventTypeID] = nil
   }

   func getHandler<E: InputEvent>(for _: E) -> (any InputEventHandler)? {
      handlers[E.eventTypeID]
   }

   private var handlers: [InputEventTypeID: any InputEventHandler] = [:]
}
