//
//  EventHandlerStore.swift
//
//
//  Created by Vova on 14.01.2024.
//

protocol EventHandlerStoreProtocol: AnyObject {

   func isHandlerRegistered<E: InputEvent>(for _: E.Type) -> Bool

   func registerHandler(_ handler: some InputEventHandler)

   func getHandler(for _: some InputEvent) -> (any InputEventHandler)?
}

final class EventHandlerStore: EventHandlerStoreProtocol {

   func isHandlerRegistered<E: InputEvent>(for _: E.Type) -> Bool {
      handlers.keys.contains(E.eventTypeID)
   }

   func registerHandler<E: InputEvent>(_ handler: some InputEventHandler<E>) {
      handlers[E.eventTypeID] = handler
   }

   func getHandler<E: InputEvent>(for _: E) -> (any InputEventHandler)? {
      handlers[E.eventTypeID]
   }

   private var handlers: [InputEventTypeID: any InputEventHandler] = [:]
}
