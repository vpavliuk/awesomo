//
//  MessageContent+Equatable.swift
//  Domain
//
//  Created by Vova on 09.11.2023.
//

import Foundation
import Domain

extension MessageContent: Equatable {
   public static func == (lhs: MessageContent, rhs: MessageContent) -> Bool {
      let semaphore = DispatchSemaphore(value: 0)
      var lhsData = Data()
      lhs.dataPublisher.sink(
         receiveCompletion: { _ in
            semaphore.signal()
         }, receiveValue: { data in
            lhsData.append(data)
         }
      )
      semaphore.wait()

      var rhsData = Data()
      rhs.dataPublisher.sink(
         receiveCompletion: { _ in
            semaphore.signal()
         }, receiveValue: { data in
            rhsData.append(data)
         }
      )
      semaphore.wait()

      return lhs.contentID == rhs.contentID && lhsData == rhsData
   }
}
