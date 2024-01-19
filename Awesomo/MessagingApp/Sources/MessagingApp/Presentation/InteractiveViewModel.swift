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
      userInputMerger: UserInputMergerProtocol
   ) {
      self.state = .fromDomainState(initialState)

      domainSource
         .map(PresentationState.fromDomainState)
         .assign(to: &$state)
      userInputMerger.merge(publisher: userInput)
   }

   // An outgoing stream of app events
   let userInput: some Subject<ConcreteUserInput, Never> = PassthroughSubject()

   // Source of truth for the view
   @Published
   private(set) var state: PresentationState
}
