//
//  ViewModel.swift
//
//
//  Created by Vova on 27.11.2023.
//

import Combine

class ViewModel<DomainState, PresentationState: DomainDerivable>: ObservableObject
      where PresentationState.DomainState == DomainState {

   required init(domainStore: DomainStore<DomainState>) {
      self.state = .fromDomainState(domainStore.state)

      domainStore.$state
         .map(PresentationState.fromDomainState)
         .assign(to: &$state)
   }

   // Source of truth for the view
   @Published
   private(set) var state: PresentationState
}
