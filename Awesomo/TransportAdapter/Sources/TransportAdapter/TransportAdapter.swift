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

public final class TransportAdapter {
   public init() {
      appInterfaceInternal = PassthroughTwoWayInterface()
      appInterface = appInterfaceInternal.eraseToAny()

      tcpInterfaceInternal = PassthroughTwoWayInterface()
      tcpInterface = tcpInterfaceInternal.eraseToAny()
   }

   public let appInterface: AnyTwoWayInterface<InputFromApp, OutputForApp>
   private let appInterfaceInternal: PassthroughTwoWayInterface<InputFromApp, OutputForApp>
   public typealias InputFromApp = TransportSendRequest<String>
   public typealias OutputForApp = InputFromTransport<String>

   public let tcpInterface: AnyTwoWayInterface<TCPInterfaceInput, TCPUpload>
   private let tcpInterfaceInternal: PassthroughTwoWayInterface<TCPInterfaceInput, TCPUpload>
   public typealias TCPInterfaceInput = TCPTransfer<TCPUpload>.Output

   public func wireUp() {
   #warning("Can this be put in init?")
      let appInputShare = appInterfaceInternal.input.publisher
      subscriptions.insert(
         appInputShare.sink { [weak self] sendRequest in
            self?.pendingSendRequest = sendRequest
         }
      )
      appInputShare
         .map { sendRequest in
            TCPUpload(
               receiverServiceName: sendRequest.receiver,
               message: .completeDomainMessage(
                  DomainMessageTCPRepresentation(
                     id: nil,
                     messageType: self.messageType(from: sendRequest.message),
                     payload: Data()
                  )
               )
            )
         }
         .subscribe(tcpInterfaceInternal.outputUpstream)
         .store(in: &subscriptions)

      tcpInterfaceInternal.input.publisher
         .map { [weak self] _ in .sendSuccess(self!.pendingSendRequest!.id) }
         .subscribe(appInterfaceInternal.outputUpstream)
         .store(in: &subscriptions)
   }

   private var subscriptions = Set<AnyCancellable>()

   private func messageType(from message: NetworkMessage) -> DomainMessageType {
      switch message {
      case .chatRequest(_):
         return .chatRequest
      case .chatMessage(_):
         return .chatMessage
      }
   }

   private var pendingSendRequest: InputFromApp?
}
