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

final class TCPTransferMock {
   lazy var interface = interfaceInternal.eraseToAny()
   private let interfaceInternal = PassthroughTwoWayInterface<TCPUpload, TCPTransfer<TCPUpload>.Output>()

   func wireUp() {
      subscription = interfaceInternal.input
         .map { .sent($0.id) }
         .delay(for: .seconds(1), scheduler: RunLoop.main, options: .none)
         .subscribe(interfaceInternal.output)
   }

   private var subscription: AnyCancellable?
}
