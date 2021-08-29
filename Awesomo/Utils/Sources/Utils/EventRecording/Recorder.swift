//
//  Recorder.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Combine

extension Publisher {
   public func record<Storage: EventStorage>(storage: Storage)
         where Storage.Event == Output {

      subscribe(Subscribers.Recorder<Storage, Failure>(storage: storage))
   }
}

extension Subscribers {
   final class Recorder<Storage: EventStorage, Failure: Error> {
      public init(storage: Storage) {
         self.storage = storage
      }

      private let storage: Storage
   }
}

extension Subscribers.Recorder: Subscriber {
   public func receive(subscription: Subscription) {
      subscription.request(.unlimited)
   }

   public func receive(_ input: Storage.Event) -> Subscribers.Demand {
      storage.add(input)
      return .unlimited
   }

   public func receive(completion: Subscribers.Completion<Failure>) {
      storage.complete()
   }
}
