//
//  OutgoingState.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 01.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public final class OutgoingState
      <User: Peer, OutboxMessage: Message>: ObservableObject {

   internal init(
      senderId: User.ID,
      outbox: [User.ID: Set<OutboxMessage>] = [:],
      sent: [User.ID: Set<OutboxMessage>] = [:]
   ) {
      self.senderId = senderId
      self.pendingUploads = []
      self.outbox = outbox
      self.sent = sent
   }

   public typealias ConcreteUpload = Upload<User, OutboxMessage>
   internal var pendingUploads: [ConcreteUpload]

   /// Messages currently being sent per receiver id
   @Published public var outbox: [User.ID: Set<OutboxMessage>]

   /// Sent messages per receiver id
   @Published public var sent: [User.ID: Set<OutboxMessage>]

   public let didEnqueueUpload = PassthroughSubject<ConcreteUpload, Never>()

   public func send(message: OutboxMessage, to receiver: User) throws {
      try putToOutbox(message: message, for: receiver.id)
      let networkMessage = NetworkMessage<User, OutboxMessage.Payload>(
         sender: senderId,
         payload: message.payload
      )
      let upload = Upload<User, OutboxMessage>(
         receiver: receiver,
         networkMessage: networkMessage,
         domainMessageId: message.id
      )
      pendingUploads.append(upload)
      didEnqueueUpload.send(upload)
   }

   internal func onUploadComplete(id: ConcreteUpload.ID) {
      let filteredUploads = pendingUploads.filter{$0.id == id}
      guard let upload = filteredUploads.first else { return }

      moveToSent(messageId: upload.domainMessageId, for: upload.receiver.id)
      pendingUploads.removeAll{$0.id == upload.id}
   }

   private func putToOutbox(message: OutboxMessage, for receiverId: User.ID) throws {
      let allValues: [Set<OutboxMessage>] = Array(outbox.values) + Array(sent.values)
      let allMessages: [OutboxMessage] = allValues.flatMap{Array($0)}
      guard !allMessages.contains(message) else {
         throw CoreMessagingError.invalidArgument(arg: message)
      }

      var outboxMessages = outbox[receiverId] ?? Set()
      outboxMessages.insert(message)
      outbox[receiverId] = outboxMessages
   }

   private func moveToSent(messageId: OutboxMessage.ID, for receiverId: User.ID) {
      let filteredOutbox = outbox[receiverId]!.filter{$0.id == messageId}
      assert(filteredOutbox.count == 1)
      let message = filteredOutbox.first!
      outbox[receiverId]!.remove(message)

      var sentMessages = sent[receiverId] ?? Set()
      assert(!sentMessages.contains(message))
      sentMessages.insert(message)
      sent[receiverId] = sentMessages
   }

   internal let senderId: User.ID
}
