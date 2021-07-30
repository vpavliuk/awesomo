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

   associatedtype OutputPublisher: Publisher where OutputPublisher.Failure == Never
   var output: OutputPublisher { get }
}

public extension TwoWayInterface {
   func eraseToAny() -> AnyTwoWayInterface<InputSubject.Output, OutputPublisher.Output> {
      AnyTwoWayInterface(self)
   }
}

// Type-erased version of TwoWayInterface
#warning("Doesn't actually conform to TwoWayInterface due to Input device type mismatch")
public struct AnyTwoWayInterface<Input, Output> {

   init<Base: TwoWayInterface>(_ base: Base) where
      Base.InputSubject.Output == Input,
      Base.OutputPublisher.Output == Output {

      input = AnySubscriber(base.input)
      output = base.output.eraseToAnyPublisher()
   }

   public let input: AnySubscriber<Input, Never>
   public let output: AnyPublisher<Output, Never>
}

public struct PassthroughTwoWayInterface<Input, Output>: TwoWayInterface {
   public init() {}
   public let input = PassthroughSubject<Input, Never>()
   public let output = PassthroughSubject<Output, Never>()
}
