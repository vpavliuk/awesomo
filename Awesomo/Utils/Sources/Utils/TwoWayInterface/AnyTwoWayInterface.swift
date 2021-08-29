//
//  AnyTwoWayInterface.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

extension TwoWayInterface {
   public func eraseToAny() -> AnyTwoWayInterface<InputSubscriber.Input, OutputUpstream.Output> { AnyTwoWayInterface(self) }
}

/// A type-erased implementation of TwoWayInterface
public struct AnyTwoWayInterface<Input, Output>: TwoWayInterface {

   init<Base: TwoWayInterface>(_ base: Base) where
         Base.InputSubscriber.Input == Input,
         Base.OutputUpstream.Output == Output {

      input = AnySubscriber(base.input)
      outputUpstream = base.outputUpstream.eraseToAnyPublisher()
      output = outputUpstream.share()
   }

   public let input: AnySubscriber<Input, Never>
   public let outputUpstream: AnyPublisher<Output, Never>
   public let output: Publishers.Share<OutputUpstream>
}
