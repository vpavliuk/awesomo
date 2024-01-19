//
//  ViewModelBuilder.swift
//
//
//  Created by Vova on 15.12.2023.
//

import Combine
import Domain

final class ViewModelBuilder: ViewModelBuilderProtocol, ObservableObject {

   init(domainStore: DomainStore<CoreMessenger.State>, userInputMerger: UserInputMergerProtocol) {
      self.domainStore = domainStore
      self.userInputMerger = userInputMerger
   }

   func buildViewModel<PresentationState, VM: ViewModel<CoreMessenger.State, PresentationState>>(of _: VM.Type) -> VM {
      return buildViewModel(of: VM.self, stateExtractor: { $0 })
   }

   func buildViewModel<
      ExtractedDomainState,
      PresentationState,
      VM: ViewModel<ExtractedDomainState, PresentationState>
   >(
      of _: VM.Type,
      stateExtractor: @escaping (CoreMessenger.State) -> ExtractedDomainState
   ) -> VM {
      return VM(
         initialState: stateExtractor(domainStore.state),
         domainSource: domainStore
            .$state
            .map(stateExtractor)
      )
   }

   func buildViewModel<PresentationState, Input: UserInput, IVM: InteractiveViewModel<CoreMessenger.State, PresentationState, Input>>(of _: IVM.Type)
         -> IVM { buildViewModel(of: IVM.self, stateExtractor: { $0 }) }

   func buildViewModel<
      ExtractedDomainState,
      PresentationState,
      Input: UserInput,
      IVM: InteractiveViewModel<ExtractedDomainState, PresentationState, Input>
   >(
      of _: IVM.Type,
      stateExtractor: @escaping (CoreMessenger.State) -> ExtractedDomainState
   ) -> IVM {
      let initialState = stateExtractor(domainStore.state)
      let domainSource = domainStore
         .$state
         .map(stateExtractor)
      return IVM(
         initialState: initialState,
         domainSource: domainSource,
         userInputMerger: userInputMerger
      )
   }

   private let domainStore: DomainStore<CoreMessenger.State>
   private let userInputMerger: UserInputMergerProtocol
}
