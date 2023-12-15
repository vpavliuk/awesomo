//
//  ViewModelBuilderProtocol.swift
//  
//
//  Created by Vova on 15.12.2023.
//

import Combine
import Domain

protocol ViewModelBuilderProtocol: ObservableObject {
   func buildViewModel<PS, VM: ViewModel<CoreMessenger.State, PS>>() -> VM
}
