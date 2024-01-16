//
//  DomainStore.swift
//
//
//  Created by Vova on 16.01.2024.
//

import Domain
import Combine

final class DomainStore<DomainState>: ObservableObject {
   init(initialState: DomainState) {
      state = initialState
   }

   @Published
   var state: DomainState
}
