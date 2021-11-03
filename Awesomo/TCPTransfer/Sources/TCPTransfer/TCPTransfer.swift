//
//  TCPTransfer.swift
//  TCP Transfer
//
//  Created by Volodymyr Pavliuk on 30.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Utils
import Combine

public final class TCPTransfer<ConcreteUpload: Upload> {
   public init(localServiceName: String, serviceType: String) {
      self.localServiceName = localServiceName
      self.serviceType = serviceType
      interfaceInternal = PassthroughTwoWayInterface()
      interface = interfaceInternal.eraseToAny()
   }

   public let interface: AnyTwoWayInterface<ConcreteUpload, Output>

   private let interfaceInternal: PassthroughTwoWayInterface<ConcreteUpload, Output>

   public enum Output {
      case received(ConcreteUpload.Message)
      #warning("Use result for sent/failure?")
      case sent(ConcreteUpload.ID)
      case failedSending(ConcreteUpload.ID)
   }

   public func wireUp() throws {
      client.wireUp()

      interfaceInternal.input.publisher.subscribe(client.interface.input)

      subscription = client.interface.output
         .merge(with: listener.output)
         .subscribe(interfaceInternal.outputUpstream)

      try listener.startListening()
   }

   private var subscription: AnyCancellable?

   private let localServiceName: String
   private let serviceType: String

   private lazy var listener = TCPServer<ConcreteUpload>(
      serviceName: localServiceName,
      serviceType: serviceType
   )
   private lazy var client = TCPClient<ConcreteUpload>(bonjourServiceType: serviceType)
}

#warning("Make a struct")
public protocol Upload: Identifiable {
   associatedtype Message: Codable
   var message: Message { get }
   var receiverServiceName: String { get }
}
