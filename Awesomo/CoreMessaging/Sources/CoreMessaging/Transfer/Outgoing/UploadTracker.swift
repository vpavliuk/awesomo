//
//  UploadTracker.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 30.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

/// Tracks outgoing transfers that have been sent over network
final class UploadTracker<User: Peer, OutboxMessage: Message> {
   typealias State = OutgoingState<User, OutboxMessage>

   init(state: State) {
      self.state = state
   }

   public typealias Input = Upload<User, OutboxMessage>.ID

   public func trackUploads<UploadPublisher: Publisher>(
      publisher: UploadPublisher
   ) where
         UploadPublisher.Output == Input,
         UploadPublisher.Failure == Never {

      uploadSubscription?.cancel()
      uploadSubscription = publisher.sink { uploadId in
         self.state.onUploadComplete(id: uploadId)
      }
   }

   private let state: State
   private var uploadSubscription: AnyCancellable?
}
