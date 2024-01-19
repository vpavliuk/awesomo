//
//  ViewModel.swift
//
//
//  Created by Vova on 27.11.2023.
//

import Combine

class ViewModel<DomainState, PresentationState: DomainDerivable>: ObservableObject
      where PresentationState.DomainState == DomainState {

   required init(initialState: DomainState, domainSource: some Publisher<DomainState, Never>) {
      self.state = .fromDomainState(initialState)

      domainSource
         .map(PresentationState.fromDomainState)
         .assign(to: &$state)
   }

   // Source of truth for the view
   @Published
   private(set) var state: PresentationState
}
