//
//  ViewModel.swift
//
//
//  Created by Vova on 27.11.2023.
//

import Combine
import Utils

class ViewModel<DomainState, PresentationState: DomainDerivable>: ObservableObject where PresentationState.DomainState == DomainState {
   init(initialDomainState: DomainState?) {
      state = if let initialDomainState {
         PresentationState(domainState: initialDomainState)
      } else {
         PresentationState.defaultValue
      }

      domainUpdatesInternal
         .publisher
         .map(PresentationState.init)
         .assign(to: &$state)
   }

   // Source of truth for the view
   @Published
   private(set) var state: PresentationState

   // An incoming stream of domain state updates
   var domainUpdates: some Subscriber<DomainState, Never> { domainUpdatesInternal }
   private let domainUpdatesInternal = PublishingSubscriber<DomainState, Never>()
}
