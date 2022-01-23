//
//  PublishingSubscriber.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 22.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public final class PublishingSubscriber<Input, Failure: Error>: Subscriber {
   private var subscription: Subscription? = nil

   private lazy var sink = Subscribers.Sink { [weak self] completion in
      self?.publisherInternal.send(completion: completion)
   } receiveValue: { [weak self] input in
      self?.publisherInternal.send(input)
   }

   private let publisherInternal = PassthroughSubject<Input, Failure>()
   public lazy var publisher = publisherInternal.share()

   public func receive(subscription: Subscription) {
      sink.receive(subscription: subscription)
   }

   public func receive(_ input: Input) -> Subscribers.Demand {
      return sink.receive(input)
   }

   public func receive(completion: Subscribers.Completion<Failure>) {
      sink.receive(completion: completion)
   }
}
