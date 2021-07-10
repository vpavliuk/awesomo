//
//  TestServiceEvent.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 17.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging

struct TestServiceEvent: AvailabilityEvent, Hashable {
   typealias BonjourService = TestBonjourService
   var type: AvailabilityEventType
   var object: TestBonjourService
}
