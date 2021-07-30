//
//  TransportAdapter.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Utils
import Combine
import MessagingApp

public final class TransportAdapter {
   public init() {}

   public lazy var appInterface: AnyTwoWayInterface<SendRequest, Int> = appInterfaceInternal.eraseToAny()
   private let appInterfaceInternal = PassthroughTwoWayInterface<SendRequest, Int>()

   public lazy var tcpInterface: AnyTwoWayInterface<Bool, String> = tcpInterfaceInternal.eraseToAny()
   private let tcpInterfaceInternal = PassthroughTwoWayInterface<Bool, String>()

   #warning("Can this be put in init?")
   public func wireUp() {
      appInterfaceInternal.input
         .map(\.receiver)
         .map { "Hello " + $0 }
         .subscribe(tcpInterfaceInternal.output)
         .store(in: &subscriptions)
   }

   private var subscriptions = Set<AnyCancellable>()
}
