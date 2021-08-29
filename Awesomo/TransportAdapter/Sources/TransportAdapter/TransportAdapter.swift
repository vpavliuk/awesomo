//
//  TransportAdapter.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine
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

   public let appInterface: AnyTwoWayInterface<SendRequest, TransportOutput>
   private let appInterfaceInternal: PassthroughTwoWayInterface<SendRequest, TransportOutput>

   public let tcpInterface: AnyTwoWayInterface<TCPTransfer<TCPUpload>.Output, TCPUpload>
   private let tcpInterfaceInternal: PassthroughTwoWayInterface<TCPTransfer<TCPUpload>.Output, TCPUpload>

   public func wireUp() {
   #warning("Can this be put in init?")
      appInterfaceInternal.input.publisher
         .map { _ in
            TCPUpload(
               receiverServiceName: "best_friend",
               message: .completeDomainMessage(
                  DomainMessageTCPRepresentation(
                     id: nil,
                     messageType: .chatMessage,
                     payload: Data()
                  )
               )
            )
         }
         .subscribe(tcpInterfaceInternal.outputUpstream)
         .store(in: &subscriptions)

      tcpInterfaceInternal.input.publisher
         .map { _ in .sendSuccess(SendRequest.ID()) }
         .subscribe(appInterfaceInternal.outputUpstream)
         .store(in: &subscriptions)
   }

   private var subscriptions = Set<AnyCancellable>()
}
