//
//  PassthroughTwoWayInterface.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public struct PassthroughTwoWayInterface<Input, Output>: TwoWayInterface {
   public init() {
      input = PublishingSubscriber()
      outputUpstream = PassthroughSubject()
      output = outputUpstream.share()
   }

   public let input: PublishingSubscriber<Input, Never>
   public let outputUpstream: PassthroughSubject<Output, Never>
   public let output: Publishers.Share<OutputUpstream>
}
