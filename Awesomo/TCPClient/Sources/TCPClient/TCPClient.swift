//
//  TCPClient.swift
//
//
//  Created by Volodymyr Pavliuk on 3/7/20.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Network
import Combine

public final class TCPClient {

   public init(bonjourServiceType: String) {
      serviceType = bonjourServiceType
   }

   public func performUpload(_ data: Data, to networkAddress: String) async throws {
      return try await withCheckedThrowingContinuation { continuation in
         performUpload(data, to: networkAddress) { error in
            if let error {
               continuation.resume(throwing: error)
            }
            continuation.resume()
         }
      }
   }

   private let serviceType: String

   private let queue = DispatchQueue(label: "com.vp.tcp-client-queue")
   private var interfaceSubscription: AnyCancellable?

   private func performUpload(
      _ upload: Data,
      to networkAddress: String,
      onDataTransferred: @escaping (NWError?) -> Void
   ) {
      let tcpData = upload
//      guard let tcpData = try? JSONEncoder().encode(upload.message) else {
//         return
//      }

      let endpoint: NWEndpoint = .service(
         name: networkAddress,
         type: serviceType,
         domain: "local.",
         interface: nil
      )
      let connection = NWConnection(to: endpoint, using: .tcp)
      connection.stateUpdateHandler = { state in
         switch state {
         case .ready:
            let completion = NWConnection.SendCompletion.contentProcessed { error in
               connection.cancel()
               onDataTransferred(nil)
            }
            connection.send(content: tcpData, completion: completion)

         case .failed(let error):
            onDataTransferred(error)

         default:
            break
         }
      }
      connection.start(queue: queue)
   }
}
