//
//  Message.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 18.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

public protocol Message: Hashable, Identifiable {
   associatedtype Payload: Codable
   init(payload: Payload)

   var payload: Payload { get }
}
