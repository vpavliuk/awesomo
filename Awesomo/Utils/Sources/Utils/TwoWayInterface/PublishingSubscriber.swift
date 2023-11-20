//
//  PublishingSubscriber.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 22.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public final class PublishingSubscriber<Input, Failure: Error>: Subscriber {
   public init() {}

   private lazy var sink = Subscribers.Sink { [weak self] completion in
      self?.subject.send(completion: completion)
   } receiveValue: { [weak self] input in
      self?.subject.send(input)
   }

   private let subject: some Subject<Input, Failure> = PassthroughSubject()
   public lazy var publisher: some Publisher<Input, Failure> = subject.share()

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
