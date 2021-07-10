//
//  TestBonjourBrowser.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 17.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging
import Combine

struct TestBonjourBrowser: FocusedEventStreamer {
   typealias Output = Set<TestServiceEvent>
   let publisher = PassthroughSubject<Output, Never>()

   func dispatchFoundService(_ service: TestBonjourService) {
      publisher.send(
         [TestServiceEvent(type: .found, object: service)]
      )
   }

   func dispatchLostService(_ service: TestBonjourService) {
      publisher.send(
         [TestServiceEvent(type: .lost, object: service)]
      )
   }
}
