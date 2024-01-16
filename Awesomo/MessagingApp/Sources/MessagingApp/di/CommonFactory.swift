//
//  AppFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

import Domain
import Combine

enum CommonFactory {

   static let domainStore = DomainStore(initialState: CoreMessenger.State.loadingSavedChats)
   static let userInputSink = PassthroughSubject<any UserInput, Never>()
   static let userInputMerger: UserInputMergerProtocol = UserInputMerger(userInputSink: userInputSink)

   #warning("Make sure that static let is lazy")
   static let viewModelBuilder: any ViewModelBuilderProtocol = ViewModelBuilder(
      domainStore: domainStore,
      userInputMerger: userInputMerger,
      eventHandlerStore: eventHandlerStore
   )

   static let eventHandlerStore: EventHandlerStoreProtocol = EventHandlerStore()

   static let coreMessenger = CoreMessenger()

   static let commonInputHandler: some InputEventHandler<CommonInput> = CommonInputHandler(
      coreMessenger: coreMessenger,
      domainStore: domainStore
   )

   static let peerAvailabilityHandler: some InputEventHandler<PeerAvailabilityEvent> = PeerAvailabilityHandler(
      coreMessenger: coreMessenger,
      domainStore: domainStore
   )
}
