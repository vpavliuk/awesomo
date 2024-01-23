//
//  TCPClient.swift
//  TCPTransfer
//
//  Created by Volodymyr Pavliuk on 3/7/20.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Network
import Combine
import Utils

final class TCPClient {

   init(bonjourServiceType: String) {
      self.serviceType = bonjourServiceType
   }

   lazy var interface: AnyTwoWayInterface = interfaceInternal.eraseToAny()

   func wireUp() {
      interfaceSubscription = interfaceInternal.input.publisher.sink { upload in
         self.performUpload(upload) {
            self.interfaceInternal.outputUpstream.send(.sent(upload.id))
         }
      }
   }

   private let serviceType: String

   private let queue = DispatchQueue(label: "com.vp.tcp-client-queue")
   private var interfaceSubscription: AnyCancellable?

   private func performUpload(
      _ upload: Upload,
      onDataTransferred: @escaping () -> Void
   ) {
      guard let tcpData = try? JSONEncoder().encode(upload.message) else {
         #warning("Handle encoding failure")
         return
      }

      let endpoint: NWEndpoint = .service(
         name: upload.receiverServiceName,
         type: serviceType,
         domain: "local.",
         interface: nil
      )
      let connection = NWConnection(to: endpoint, using: .tcp)
      connection.stateUpdateHandler = { state in
         if state == .ready {
            let completion = NWConnection.SendCompletion.contentProcessed { error in
               connection.cancel()
               onDataTransferred()
            }
            connection.send(content: tcpData, completion: completion)
         }
      }
      connection.start(queue: self.queue)
   }

   private let interfaceInternal =
         PassthroughTwoWayInterface<Upload, TCPTransfer.Output>()
}
