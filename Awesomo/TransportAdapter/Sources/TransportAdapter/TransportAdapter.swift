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
   public init() {}

   public lazy var appInterface: AnyTwoWayInterface<SendRequest, TransportOutput> = appInterfaceInternal.eraseToAny()
   private let appInterfaceInternal = PassthroughTwoWayInterface<SendRequest, TransportOutput>()

   public lazy var tcpInterface: AnyTwoWayInterface<TCPTransfer<TCPUpload>.Output, TCPUpload> = tcpInterfaceInternal.eraseToAny()
   private let tcpInterfaceInternal = PassthroughTwoWayInterface<TCPTransfer<TCPUpload>.Output, TCPUpload>()

   public func wireUp() {
   #warning("Can this be put in init?")
      appInterfaceInternal.input
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
         .subscribe(tcpInterfaceInternal.output)
         .store(in: &subscriptions)

      tcpInterfaceInternal.input
         .map { _ in .sendSuccess(SendRequest.ID()) }
         .subscribe(appInterfaceInternal.output)
         .store(in: &subscriptions)
   }

   private var subscriptions = Set<AnyCancellable>()
}
