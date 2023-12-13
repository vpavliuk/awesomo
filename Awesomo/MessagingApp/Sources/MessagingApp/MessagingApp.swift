import Utils
import Domain
import Combine
import SwiftUI

enum AppError: Error {
   case couldNotFindHandlerForInputEvent(any InputEvent)
}

public final class MessagingApp<ContentNetworkRepresentation>: ObservableObject {
   public init() {
      inputInternal = PublishingSubscriber()
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

   private lazy var inputHandlers: [any InputHandler] = [
      CommonInputHandler(),
      PeerAvailabilityHandler(coreMessenger: coreMessenger) { [weak self] state in self?.domainState = state },
      PeerListUserInputHandler { [weak self] peerID in self?.activeScreen = .selectedPeer(peerID) },
   ]

   private func on(event: some InputEvent) throws {
      var isHandled = false
      var iterator = inputHandlers.makeIterator()
      while let handler = iterator.next(), !isHandled {
         isHandled = tryHandle(event, with: handler)
      }
      if !isHandled {
         throw AppError.couldNotFindHandlerForInputEvent(event)
      }
   }

   private func tryHandle<H: InputHandler>(_ event: some InputEvent, with handler: H) -> Bool {
      guard let event = event as? H.Event else {
         return false
      }
      handler.on(event)
      return true
   }

   public lazy var input: some Subscriber<any InputEvent, Never> = inputInternal
   private let inputInternal: PublishingSubscriber<any InputEvent, Never>

   private let coreMessenger = CoreMessenger()

   @Published
   private(set) var activeScreen: ActiveScreen = .peerList

   public private(set) var domainState: CoreMessenger.State = .loadingSavedChats

   lazy var domainPublisher = CurrentValueSubject<CoreMessenger.State, Never>(domainState)

   public var entryPointView: some View {
      EntryPointView()
         .environmentObject(self)
   }
}

enum ActiveScreen {
   case peerList
   case selectedPeer(Peer.ID)
}
