//
//  ViewModelBuilderProtocol.swift
//  
//
//  Created by Vova on 15.12.2023.
//

import Combine
import Domain

protocol ViewModelBuilderProtocol: ObservableObject {

   func buildViewModel<PS, VM: ViewModel<CoreMessenger.State, PS>>(of _: VM.Type) -> VM

   func buildInteractiveViewModel<PS, UI: UserInput, IVM: InteractiveViewModel<CoreMessenger.State, PS, UI>>(
      of _: IVM.Type,
      userInputHandler: some InputEventHandler<UI>
   ) -> IVM
}
