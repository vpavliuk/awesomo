//
//  TwoWayInterface.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public protocol TwoWayInterface {
   #warning("Subect vs Subscriber")
   associatedtype InputSubject: Subject where InputSubject.Failure == Never
   var input: InputSubject { get }

   associatedtype OutputPublisher: Publisher
   var output: OutputPublisher { get }
}

public struct AnyTwoWayInterface<Input, Output, OutputFailure: Error> {

   init<Base: TwoWayInterface>(_ base: Base) where
      Base.InputSubject.Output == Input,
      Base.OutputPublisher.Output == Output,
      Base.OutputPublisher.Failure == OutputFailure {

      input = AnySubscriber(base.input)
      output = base.output.eraseToAnyPublisher()
   }

   public let input: AnySubscriber<Input, Never>
   public let output: AnyPublisher<Output, OutputFailure>
}

extension TwoWayInterface {
   func eraseToAny() -> AnyTwoWayInterface<
      InputSubject.Output,
      OutputPublisher.Output,
      OutputPublisher.Failure
   > { AnyTwoWayInterface(self) }
}
