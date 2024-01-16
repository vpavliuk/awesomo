import Utils
import Domain
import Combine
import SwiftUI

public final class MessagingApp<ContentNetworkRepresentation> {

   init(
      coreMessenger: CoreMessenger,
      userInputSink: AnyPublisher<any UserInput, Never>,
      viewModelBuilder: some ViewModelBuilderProtocol,
      handlerStore: some EventHandlerStoreProtocol,
      commonInputHandler: some InputHandler<CommonInput>,
      peerAvailabilityHandler: some InputHandler<PeerAvailabilityEvent>
   ) {
      self.inputInternal = PublishingSubscriber()
      self.coreMessenger = coreMessenger
      self.userInputSink = userInputSink
      self.viewModelBuilder = viewModelBuilder
      self.handlerStore = handlerStore
      self.commonInputHandler = commonInputHandler
      self.peerAvailabilityHandler = peerAvailabilityHandler
   }

   deinit {
      try! handlerStore.unregisterHandler(for: CommonInput.self)
      try! handlerStore.unregisterHandler(for: PeerAvailabilityEvent.self)
   }

   public func wireUp() {
      try! handlerStore.registerHandler(commonInputHandler)
      try! handlerStore.registerHandler(peerAvailabilityHandler)

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

   private func handle<H: InputHandler>(_ event: some InputEvent, with handler: H) throws {
      guard let event = event as? H.Event else {
         throw AppError.wrongHandlerForInputEvent(event, handler)
      }
      handler.on(event)
   }

   public func makeEntryPointView() -> some View {
      AnyView(
         ChatEntryPointView()
            .environmentObject(viewModelBuilder)
      )
   }

   public lazy var input: some Subscriber<any InputEvent, Never> = inputInternal
   public let userInputSink: AnyPublisher<any UserInput, Never>

   private let viewModelBuilder: any ViewModelBuilderProtocol
   private let handlerStore: any EventHandlerStoreProtocol
   private var subscription: AnyCancellable?
   #warning("A Sink subscriber might be sufficient")
   private let inputInternal: PublishingSubscriber<any InputEvent, Never>
   private let coreMessenger: CoreMessenger
   private let commonInputHandler: any InputHandler<CommonInput>
   private let peerAvailabilityHandler: any InputHandler<PeerAvailabilityEvent>
}

extension MessagingApp {
   public convenience init() {
      self.init(
         coreMessenger: CommonFactory.coreMessenger,
         userInputSink: CommonFactory.userInputSink.eraseToAnyPublisher(),
         viewModelBuilder: CommonFactory.viewModelBuilder,
         handlerStore: CommonFactory.eventHandlerStore,
         commonInputHandler: CommonFactory.commonInputHandler,
         peerAvailabilityHandler: CommonFactory.peerAvailabilityHandler
      )
   }
}
