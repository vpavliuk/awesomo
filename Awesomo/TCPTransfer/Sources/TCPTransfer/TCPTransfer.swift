//
//  TCPTransfer.swift
//  TCP Transfer
//
//  Created by Volodymyr Pavliuk on 30.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Utils
import Combine
import Foundation

public final class TCPTransfer {
   public init(localServiceName: String, serviceType: String) {
      self.localServiceName = localServiceName
      self.serviceType = serviceType
      interfaceInternal = PassthroughTwoWayInterface()
      interface = interfaceInternal.eraseToAny()
   }

   public let interface: AnyTwoWayInterface<Upload, Output>

   private let interfaceInternal: PassthroughTwoWayInterface<Upload, Output>

   public enum Output {
      case received(Data)
      #warning("Use result for sent/failure?")
      case sent(Upload.ID)
      case failedSending(Upload.ID)
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

   private lazy var listener = TCPServer(
      serviceName: localServiceName,
      serviceType: serviceType
   )
   private lazy var client = TCPClient(bonjourServiceType: serviceType)
}

#warning("Make a struct")
#warning("Investigate possibility of using a stream of data")
public struct Upload: Identifiable {
   public let id: UUID
   let message: Data
   let receiverServiceName: String
}
