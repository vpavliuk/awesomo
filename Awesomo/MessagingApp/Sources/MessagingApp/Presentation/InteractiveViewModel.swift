//
//  InteractiveViewModel.swift
//
//
//  Created by Vova on 16.01.2024.
//

import Combine

class InteractiveViewModel<DomainState, PresentationState: DomainDerivable, ConcreteUserInput: UserInput>: ObservableObject
      where PresentationState.DomainState == DomainState {

   required init(
      initialState: DomainState,
      domainSource: some Publisher<DomainState, Never>,
      userInputMerger: UserInputMergerProtocol,
      eventHandlerStore: EventHandlerStoreProtocol,
      userInputHandler: some InputEventHandler<ConcreteUserInput>
   ) {
      self.state = .fromDomainState(initialState)
      self.eventHandlerStore = eventHandlerStore

      domainSource
         .map(PresentationState.fromDomainState)
         .assign(to: &$state)
      userInputMerger.merge(publisher: userInput)
      #warning("Handle error")
      try! eventHandlerStore.registerHandler(userInputHandler)
   }

   deinit {
      #warning("Handle error")
      try! eventHandlerStore.unregisterHandler(for: ConcreteUserInput.self)
   }

   private let eventHandlerStore: EventHandlerStoreProtocol

   // An outgoing stream of app events
   let userInput: some Subject<ConcreteUserInput, Never> = PassthroughSubject()

   // Source of truth for the view
   @Published
   private(set) var state: PresentationState
}
