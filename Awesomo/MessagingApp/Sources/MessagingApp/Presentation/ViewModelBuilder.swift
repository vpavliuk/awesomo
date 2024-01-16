//
//  ViewModelBuilder.swift
//
//
//  Created by Vova on 15.12.2023.
//

import Combine
import Domain

final class ViewModelBuilder: ViewModelBuilderProtocol, ObservableObject {
   init(
      domainPublisher: CurrentValueSubject<CoreMessenger.State, Never>,
      userInputMerger: UserInputMergerProtocol,
      eventHandlerStore: EventHandlerStoreProtocol
   ) {
      self.domainPublisher = domainPublisher
      self.userInputMerger = userInputMerger
      self.eventHandlerStore = eventHandlerStore
   }

   func buildViewModel<PS, VM: ViewModel<CoreMessenger.State, PS>>() -> VM {
      return VM(domainSource: domainPublisher)
   }

   func buildInteractiveViewModel<PS, UI: UserInput, IVM: InteractiveViewModel<CoreMessenger.State, PS, UI>>(userInputHandler: some InputHandler<UI>) -> IVM {
      return IVM(
         domainSource: domainPublisher,
         userInputMerger: userInputMerger,
         eventHandlerStore: eventHandlerStore,
         userInputHandler: userInputHandler
      )
   }

   private let domainPublisher: CurrentValueSubject<CoreMessenger.State, Never>
   private let userInputMerger: UserInputMergerProtocol
   private let eventHandlerStore: EventHandlerStoreProtocol
}
