//
//  TransportAdapter.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine
import Domain
import MessagingApp
import TCPTransfer
import Utils

public typealias InputFromApp = TransportSendRequest<String, UInt8> // MessagingApp.TransportSendRequest
public typealias OutputForApp = InputFromTransport<String, UInt8> // MessagingApp.InputFromTransport

public typealias TCPInterfaceInput = TCPTransfer<TCPUpload>.Output

public final class TransportAdapter {
   init(messageIDGenerator: TransportAdapterMessageIDGenerator) {
      self.messageIDGenerator = messageIDGenerator

      appInterfaceInternal = PassthroughTwoWayInterface()
      appInterface = appInterfaceInternal.eraseToAny()

      tcpInterfaceInternal = PassthroughTwoWayInterface()
      tcpInterface = tcpInterfaceInternal.eraseToAny()
   }

   public let appInterface: AnyTwoWayInterface<InputFromApp, OutputForApp>
   private let appInterfaceInternal: PassthroughTwoWayInterface<InputFromApp, OutputForApp>

   public let tcpInterface: AnyTwoWayInterface<TCPInterfaceInput, TCPUpload>
   private let tcpInterfaceInternal: PassthroughTwoWayInterface<TCPInterfaceInput, TCPUpload>

   public func wireUp() {
      subscriptions.insert(
         appInputShare.sink { [weak self] sendRequest in
            self?.pendingSendRequest = sendRequest
         }
      )

      wireUpAppToTCP()
      wireUpTCPToApp()
   }

   private func wireUpAppToTCP() {
      appInputShare
         .zip((0...Int.max).publisher)
         // Magic to avoid memory explosion
         .flatMap(maxPublishers: .max(1)) { pair in
            Just(pair)
         }
         .map(tcpUploadFromAppSendRequest)
         .subscribe(tcpInterfaceInternal.outputUpstream)
         .store(in: &subscriptions)
   }

   private func tcpUploadFromAppSendRequest(
      requestSeqNumberPair: (InputFromApp, Int)
   ) -> TCPUpload {
      let appSendRequest = requestSeqNumberPair.0
      let requestSequenceNumber = requestSeqNumberPair.1
      return TCPUpload(
         id: messageIDGenerator.tcpOutputID(seqNumber: requestSequenceNumber),
         receiverServiceName: appSendRequest.receiver,
         message: Data()
      )
   }

   private func wireUpTCPToApp() {
      tcpInterfaceInternal.input.publisher
         .map(transportOutputFromTCPInput)
         .subscribe(appInterfaceInternal.outputUpstream)
         .store(in: &subscriptions)
   }

   private func transportOutputFromTCPInput(_ tcpInput: TCPInterfaceInput) -> OutputForApp {
      switch tcpInput {
      case .sent(_):
         let success = OutputForApp.SendResult.success(self.pendingSendRequest!.id)
         return .sendResult(success)
      case .failedSending(_):
         let requestID = self.pendingSendRequest!.id
         let error = OutputForApp.SendError(requestID: requestID)
         let failure = OutputForApp.SendResult.failure(error)
         return .sendResult(failure)
      case .received(_):
         let success = OutputForApp.SendResult.success(self.pendingSendRequest!.id)
         return .sendResult(success)
      }
   }

   private var subscriptions = Set<AnyCancellable>()

   private var appInputShare: AnyPublisher<InputFromApp, Never> {
      appInterfaceInternal.input.publisher
   }

   private var pendingSendRequest: InputFromApp?

   private let messageIDGenerator: TransportAdapterMessageIDGenerator

#warning("Revise")
//   private static func messageType(from message: NetworkMessage) -> DomainMessageType {
//      switch message {
//      case .chatRequest:
//         return .chatRequest
//      case .chatMessage(_):
//         return .chatMessage
//      }
//   }
}
