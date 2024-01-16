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
      domainStore: DomainStore<CoreMessenger.State>,
      userInputMerger: UserInputMergerProtocol,
      eventHandlerStore: EventHandlerStoreProtocol
   ) {
      self.domainStore = domainStore
      self.userInputMerger = userInputMerger
      self.eventHandlerStore = eventHandlerStore
   }

   func buildViewModel<PS, VM: ViewModel<CoreMessenger.State, PS>>(of _: VM.Type) -> VM {
      return VM(domainStore: domainStore)
   }

   func buildInteractiveViewModel<PS, UI: UserInput, IVM: InteractiveViewModel<CoreMessenger.State, PS, UI>>(
      of _: IVM.Type,
      userInputHandler: some InputHandler<UI>
   ) -> IVM {
      return IVM(
         domainStore: domainStore,
         userInputMerger: userInputMerger,
         eventHandlerStore: eventHandlerStore,
         userInputHandler: userInputHandler
      )
   }

   private let domainStore: DomainStore<CoreMessenger.State>
   private let userInputMerger: UserInputMergerProtocol
   private let eventHandlerStore: EventHandlerStoreProtocol
}
