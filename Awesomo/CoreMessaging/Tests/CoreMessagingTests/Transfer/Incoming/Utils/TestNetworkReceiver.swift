//
//  TestNetworkReceiver.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 30.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging
import Combine

struct TestNetworkReceiver {
   typealias Output = NetworkMessage<TestPeer, TestMessage.Payload>
   let publisher = PassthroughSubject<Output, Never>()

   func dispatchReceivedItem(_ networkMessage: Output) {
      publisher.send(networkMessage)
   }
}
