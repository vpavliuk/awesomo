//
//  ViewModel.swift
//
//
//  Created by Vova on 27.11.2023.
//

import Combine
import Utils

class ViewModel<DomainState, PresentationState: DomainDerivable>: ObservableObject
      where PresentationState.DomainState == DomainState {

   init(domainSource: CurrentValueSubject<DomainState, Never>) {
      state = .fromDomainState(domainSource.value)

      domainSource
         .map(PresentationState.fromDomainState)
         .assign(to: &$state)
   }

   // Source of truth for the view
   @Published
   private(set) var state: PresentationState
}
