//
//  TestNetworkSender.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 30.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging
import Combine

struct TestNetworkSender: FocusedEventStreamer {
   typealias ConcreteUpload = Upload<TestPeer, TestMessage>
   typealias Output = ConcreteUpload.ID
   let publisher = PassthroughSubject<Output, Never>()

   func dispatchUploadComplete(_ upload: ConcreteUpload) {
      publisher.send(upload.id)
   }
}
