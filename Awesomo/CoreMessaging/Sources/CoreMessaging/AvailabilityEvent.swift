//
//  AvailabilityEvent.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 08.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

public protocol AvailabilityEvent {
   associatedtype Object
   var type: AvailabilityEventType { get }
   var object: Object { get }
}
