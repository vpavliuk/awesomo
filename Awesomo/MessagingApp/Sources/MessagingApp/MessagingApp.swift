import Utils
import Domain
import Combine
import SwiftUI

enum AppError: Error {
   case couldNotFindHandlerForInputEvent(any InputEvent)
}

public final class MessagingApp<ContentNetworkRepresentation> {

   public convenience init() {
      let userInputSink = PassthroughSubject<any UserInput, Never>()
      let userInputMerger: UserInputMergerProtocol = UserInputMerger(userInputSink: userInputSink)
      let initialState: CoreMessenger.State = .loadingSavedChats
      let domainPublisher = CurrentValueSubject<CoreMessenger.State, Never>(initialState)
      let viewModelBuilder: some ViewModelBuilderProtocol = ViewModelBuilder(
         domainPublisher: domainPublisher,
         userInputMerger: userInputMerger
      )

      self.init(
         userInputSinkInternal: userInputSink,
         userInputMerger: userInputMerger,
         initialState: initialState,
         domainPublisher: domainPublisher,
         viewModelBuilder: viewModelBuilder
      )
   }

   internal init(
      userInputSinkInternal: PassthroughSubject<any UserInput, Never>,
      userInputMerger: UserInputMergerProtocol,
      initialState: CoreMessenger.State,
      domainPublisher: CurrentValueSubject<CoreMessenger.State, Never>,
      viewModelBuilder: some ViewModelBuilderProtocol
   ) {
      self.inputInternal = PublishingSubscriber()
      self.userInputSinkInternal = userInputSinkInternal
      self.userInputMerger = userInputMerger
      self.domainState = initialState
      self.domainPublisher = domainPublisher
      self.viewModelBuilder = viewModelBuilder
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
      CommonInputHandler(coreMessenger: coreMessenger),
      PeerAvailabilityHandler(coreMessenger: coreMessenger) {
         [weak self] state in
         self?.domainState = state
      },
      PeerListUserInputHandler(coreMessenger: coreMessenger) { [weak self] peerID in
         self?.activeScreen = .selectedPeer(peerID)
      },
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
      domainState = handler.on(event)
      return true
   }

   public lazy var input: some Subscriber<any InputEvent, Never> = inputInternal
   private let inputInternal: PublishingSubscriber<any InputEvent, Never>

   private let coreMessenger = CoreMessenger()

   @Published
   private(set) var activeScreen: ActiveScreen = .peerList

   private var domainState: CoreMessenger.State {
      didSet {
         if domainState != oldValue {
            domainPublisher.send(domainState)
         }
      }
   }

   let domainPublisher: CurrentValueSubject<CoreMessenger.State, Never>

   public func makeEntryPointView() -> some View {
      AnyView(
         EntryPointView()
            .environmentObject(viewModelBuilder)
      )
   }

   public lazy var userInputSink: some Publisher<any UserInput, Never> = userInputSinkInternal
   private let userInputSinkInternal: PassthroughSubject<any UserInput, Never>
   private let userInputMerger: UserInputMergerProtocol
   private let viewModelBuilder: any ViewModelBuilderProtocol
}

enum ActiveScreen {
   case peerList
   case selectedPeer(Peer.ID)
}
