//
//  ViewModelBuilderProtocol.swift
//  
//
//  Created by Vova on 15.12.2023.
//

import Combine
import Domain

protocol ViewModelBuilderProtocol: ObservableObject {

   func buildViewModel<PresentationState, VM: ViewModel<CoreMessenger.State, PresentationState>>(of _: VM.Type) -> VM

   func buildViewModel<
      ExtractedDomainState,
      PresentationState,
      VM: ViewModel<ExtractedDomainState, PresentationState>
   >(
      of _: VM.Type,
      stateExtractor: @escaping (CoreMessenger.State) -> ExtractedDomainState
   ) -> VM

   func buildViewModel<PresentationState, Input: UserInput, IVM: InteractiveViewModel<CoreMessenger.State, PresentationState, Input>>(of _: IVM.Type) -> IVM

   func buildViewModel<
      ExtractedDomainState,
      PresentationState,
      Input: UserInput,
      IVM: InteractiveViewModel<ExtractedDomainState, PresentationState, Input>
   >(
      of _: IVM.Type,
      stateExtractor: @escaping (CoreMessenger.State) -> ExtractedDomainState
   ) -> IVM
}
