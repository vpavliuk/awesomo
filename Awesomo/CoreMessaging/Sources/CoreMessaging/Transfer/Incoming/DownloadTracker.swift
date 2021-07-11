//
//  DownloadTracker.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 30.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

/// Tracks incoming messages that have been received on the network
final class DownloadTracker<ConcretePeer: Peer, InboxMessage: Message> {

   typealias State = IncomingState<ConcretePeer, InboxMessage>

   init(state: State) {
      self.state = state
   }

   public typealias Input = NetworkMessage<ConcretePeer, InboxMessage.Payload>

   public func trackDownloads<DownloadPublisher: Publisher>(
      publisher: DownloadPublisher
   ) where DownloadPublisher.Output == Input, DownloadPublisher.Failure == Never {

      downloadSubscription?.cancel()
      downloadSubscription = publisher.sink { [weak self] tcpMessage in
         guard let self = self else { return }

         var messages = self.state.inbox[tcpMessage.sender] ?? Set()
         messages.insert(InboxMessage(payload: tcpMessage.payload))
         self.state.inbox[tcpMessage.sender] = messages
      }
   }

   private let state: State
   private var downloadSubscription: AnyCancellable?
}
