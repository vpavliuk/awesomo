import Utils
import Domain
import Combine
import SwiftUI

public final class MessagingApp<ContentNetworkRepresentation>: ObservableObject {

   init(
      userInputSink: AnyPublisher<any UserInput, Never>,
      handlerStore: some EventHandlerStoreProtocol,
      commonHandlers: [any InputEventHandler]
   ) {
      self.inputInternal = PublishingSubscriber()
      self.userInputSink = userInputSink
      self.handlerStore = handlerStore
      self.commonHandlers = commonHandlers
   }

   private func unregisterHandler(_ handler: some InputEventHandler) {
      try! handlerStore.unregisterHandler(for: type(of: handler).Event)
   }

   deinit {
      func unregisterHandler(_ handler: some InputEventHandler) {
         try! handlerStore.unregisterHandler(for: type(of: handler).Event)
      }

      for h in commonHandlers {
         unregisterHandler(h)
      }
   }

   public func wireUp() {
      for h in commonHandlers {
         try! handlerStore.registerHandler(h)
      }

      subscription = inputInternal
         .publisher
         .sink { [weak self] appInput in
            guard let self else { return }
            try! on(event: appInput)
         }
   }

   private func on(event: some InputEvent) throws {
      guard let handler = handlerStore.getHandler(for: event) else {
         throw AppError.couldNotFindHandlerForInputEvent(event)
      }
      try handle(event, with: handler)
   }

   private func handle<H: InputEventHandler>(_ event: some InputEvent, with handler: H) throws {
      guard let event = event as? H.Event else {
         throw AppError.wrongHandlerForInputEvent(event, handler)
      }
      handler.on(event)
   }

   public func makeEntryPointView() -> some View {
      ChatFlowEntryPointView()
   }

   public lazy var input: some Subscriber<any InputEvent, Never> = inputInternal
   public let userInputSink: AnyPublisher<any UserInput, Never>

   private let handlerStore: any EventHandlerStoreProtocol
   private let commonHandlers: [any InputEventHandler]
   private var subscription: AnyCancellable?
   #warning("A Sink subscriber might be sufficient")
   private let inputInternal: PublishingSubscriber<any InputEvent, Never>
}

extension MessagingApp {
   public convenience init() {
      self.init(
         userInputSink: CommonFactory.userInputSink.eraseToAnyPublisher(),
         handlerStore: CommonFactory.eventHandlerStore,
         commonHandlers: [
            CommonFactory.commonInputHandler,
            CommonFactory.peerAvailabilityHandler
         ]
      )
   }
}
