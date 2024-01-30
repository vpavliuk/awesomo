import Utils
import Combine
import SwiftUI

public final class App<ContentNetworkRepresentation>: ObservableObject {

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

   public func wireUp() {
      for h in commonHandlers {
         handlerStore.registerHandler(h)
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
