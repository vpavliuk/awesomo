//
//  EventStorage.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

public protocol EventStorage: AnyObject {
   associatedtype Event
   var events: [Event] { get }
   func add(_ event: Event)
   func complete()
}
