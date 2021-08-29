//
//  TwoWayInterface.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public protocol TwoWayInterface {
   associatedtype InputSubscriber: Subscriber where InputSubscriber.Failure == Never
   var input: InputSubscriber { get }

   associatedtype OutputUpstream: Publisher where OutputUpstream.Failure == Never
   var outputUpstream: OutputUpstream { get }
   var output: Publishers.Share<OutputUpstream> { get }
}

extension TwoWayInterface {
   public func connect<OtherTwoWayInterface: TwoWayInterface>(to other: OtherTwoWayInterface)
         where OtherTwoWayInterface.InputSubscriber.Input == OutputUpstream.Output,
         OtherTwoWayInterface.OutputUpstream.Output == InputSubscriber.Input {

      output.subscribe(other.input)
      other.output.subscribe(input)
   }
}

extension TwoWayInterface {
   public func startSavingOutput<Storage: EventStorage>(in storage: Storage)
         where Storage.Event == OutputUpstream.Output {
      
      output.record(storage: storage)
   }
}
