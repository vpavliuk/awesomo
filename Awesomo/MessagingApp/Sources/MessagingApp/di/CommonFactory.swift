//
//  AppFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

import Domain
import Combine

enum CommonFactory {

   static let initialState: CoreMessenger.State = .loadingSavedChats
   static let domainPublisher = CurrentValueSubject<CoreMessenger.State, Never>(initialState)
   static let userInputSink = PassthroughSubject<any UserInput, Never>()
   static let userInputMerger: UserInputMergerProtocol = UserInputMerger(userInputSink: userInputSink)

   #warning("Make sure that static let is lazy")
   static let viewModelBuilder: any ViewModelBuilderProtocol = ViewModelBuilder(
      domainPublisher: domainPublisher,
      userInputMerger: userInputMerger,
      eventHandlerStore: eventHandlerStore
   )

   static let eventHandlerStore: EventHandlerStoreProtocol = EventHandlerStore()

   static let coreMessenger = CoreMessenger()

   static let commonInputHandler: some InputHandler<CommonInput> = CommonInputHandler(coreMessenger: coreMessenger)

   static let peerAvailabilityHandler: some InputHandler<PeerAvailabilityEvent> = PeerAvailabilityHandler(coreMessenger: coreMessenger) { _ in
//      [weak self] state in
//      self?.domainState = state
   }
}
