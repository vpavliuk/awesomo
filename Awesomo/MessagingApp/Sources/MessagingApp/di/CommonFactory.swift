//
//  AppFactory.swift
//
//
//  Created by Vova on 14.01.2024.
//

import Domain
import Combine

public enum CommonFactory {
   public static func buildApp<T>(appUserID: String) -> App<T, CoreMessenger.State> {
      let appUserPeerID = Peer.ID(value: appUserID)
      return App(
         userInputSink: CommonFactory.userInputSink.eraseToAnyPublisher(),
         domainStore: domainStore,
         handlerRegistry: CommonFactory.eventHandlerRegistry,
         commonHandlers: [
            CommonFactory.commonInputHandler,
            getPeerAvailabilityHandler(appUserID: appUserPeerID),
         ]
      )
   }

   static let domainStore = DomainStore(initialState: CoreMessenger.State())
   static let userInputSink = PassthroughSubject<any UserInput, Never>()
   static let userInputMerger: UserInputMergerProtocol = UserInputMerger(userInputSink: userInputSink)

#warning("Make sure that static let is lazy")
   static let viewModelBuilder: any ViewModelBuilderProtocol = ViewModelBuilder(
      domainStore: domainStore,
      userInputMerger: userInputMerger
   )

   static let eventHandlerRegistry: EventHandlerRegistryProtocol = EventHandlerRegistry()

   static let coreMessenger = CoreMessenger()

   static let commonInputHandler: some InputEventHandler<CommonInput> = CommonInputHandler(
      coreMessenger: coreMessenger,
      domainStore: domainStore
   )

   private static func getPeerAvailabilityHandler(appUserID: Peer.ID) -> some InputEventHandler<PeerAvailabilityEvent> {
      return PeerAvailabilityHandler(
         appUserID: appUserID,
         coreMessenger: coreMessenger,
         domainStore: domainStore
      )
   }
}
