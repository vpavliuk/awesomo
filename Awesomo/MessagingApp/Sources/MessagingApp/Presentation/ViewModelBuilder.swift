//
//  ViewModelBuilder.swift
//
//
//  Created by Vova on 15.12.2023.
//

import Combine
import Domain

final class ViewModelBuilder: ViewModelBuilderProtocol, ObservableObject {
   init(
      domainPublisher: CurrentValueSubject<CoreMessenger.State, Never>,
      userInputMerger: UserInputMergerProtocol
   ) {
      self.domainPublisher = domainPublisher
      self.userInputMerger = userInputMerger
   }

   func buildViewModel<PS, VM: ViewModel<CoreMessenger.State, PS>>() -> VM {
      return VM(domainSource: domainPublisher, userInputMerger: userInputMerger)
   }

   private let domainPublisher: CurrentValueSubject<CoreMessenger.State, Never>
   private let userInputMerger: UserInputMergerProtocol
}
