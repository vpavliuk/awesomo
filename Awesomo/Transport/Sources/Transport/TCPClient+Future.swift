//
//  TCPClient+Future.swift
//
//
//  Created by Vova on 30.01.2024.
//

import Foundation
import Domain
import Combine

extension TCPClient {

   func upload(
      _ data: Data,
      to networkAddress: NetworkAddress,
      successResultValue: TransportProcessor.Output,
      failureResultValue: TransportProcessor.Output
   ) -> Future<TransportProcessor.Output, Never> {
      Future {
         do {
            try await upload(data, to: networkAddress.value)
            return successResultValue
         } catch {
            return failureResultValue
         }
      }
   }

}
