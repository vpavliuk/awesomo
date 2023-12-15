//
//  UserInputMerger.swift
//
//
//  Created by Vova on 15.12.2023.
//

import Combine

final class UserInputMerger: UserInputMergerProtocol {

   init(userInputSink: some Subject<any UserInput, Never>) {
      self.userInputSink = userInputSink
   }

   public func merge(publisher: some Publisher<some UserInput, Never>) {
      publisher.sink { [weak self] input in
         self?.userInputSink.send(input)
      }
      .store(in: &subscriptions)
   }

   private let userInputSink: any Subject<any UserInput, Never>
   private var subscriptions: Set<AnyCancellable> = []
}
