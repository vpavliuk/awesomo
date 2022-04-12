//
//  TCPTransferMock.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 14.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine
import TCPTransfer
import TransportAdapter
import Utils
import MessagingApp

final class TCPTransferMock {
   enum TransferResult {
      case success, failure
   }
   var predefinedSendResult = TransferResult.success

   lazy var interface = interfaceInternal.eraseToAny()
   private let interfaceInternal = PassthroughTwoWayInterface<TCPUpload, TCPTransfer<TCPUpload>.Output>()

   func wireUp() {
      subscription = interfaceInternal.input.publisher
         .compactMap { [weak self] inputFromTransport in
            guard let self = self else { return nil }
            switch self.predefinedSendResult {
            case .success:
               return .sent(inputFromTransport.id)
            case .failure:
               return .failedSending(inputFromTransport.id)
            }
         }
         .delay(for: .zero, scheduler: RunLoop.main, options: .none)
         .subscribe(interfaceInternal.outputUpstream)
   }

   private var subscription: AnyCancellable?
}
