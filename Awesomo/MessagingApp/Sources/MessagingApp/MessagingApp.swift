import Utils
import Domain
import Combine

enum AppError: Error {
   case couldNotFindHandlerForInputEvent(any InputEvent)
}

public final class MessagingApp<ContentNetworkRepresentation> {
   public init() {
      peerDiscoveryInterfaceInternal = PublishingSubscriber()
      inputInternal = PublishingSubscriber()

      //transportInterfaceInternal = PassthroughTwoWayInterface()
      //transportInterface = transportInterfaceInternal.eraseToAny()
   }

   private var subscription: AnyCancellable?
   public func wireUp() {
      subscription = inputInternal
         .publisher
         .sink { [weak self] appInput in
            guard let self else { return }
            try! on(event: appInput)
         }
   }

   private var inputHandlers: [any InputHandler] = []

   private func on(event: some InputEvent) throws {
      var hasBeenHandled = false
      for handler in inputHandlers {
         tryHandle(event, with: handler, success: &hasBeenHandled)
         if hasBeenHandled { break }
      }
      if !hasBeenHandled {
         throw AppError.couldNotFindHandlerForInputEvent(event)
      }
   }

   private func tryHandle<H: InputHandler>(_ event: some InputEvent, with handler: H, success: inout Bool) {
      guard let event = event as? H.Event else { return }
      handler.on(event)
      success = true
   }


   public lazy var input: some Subscriber<any InputEvent, Never> = inputInternal
   private let inputInternal: PublishingSubscriber<any InputEvent, Never>

   public var peerDiscoveryInterface: some Subscriber<PeerAvailabilityEvent, Never> { peerDiscoveryInterfaceInternal }
   private let peerDiscoveryInterfaceInternal: PublishingSubscriber<PeerAvailabilityEvent, Never>

   private let coreMessenger = CoreMessenger()

   private var subscriptions = Set<AnyCancellable>()

   @Published
   public var peers: [Peer] = []
}
