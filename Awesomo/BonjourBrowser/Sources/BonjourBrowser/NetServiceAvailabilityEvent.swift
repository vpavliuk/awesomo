//
//  NetServiceAvailabilityEvent.swift
//  Bonjour Browser
//
//  Created by Volodymyr Pavliuk on 04.05.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

public struct NetServiceAvailabilityEvent {
   public enum AvailabilityChange { case found, lost }

   public init(availabilityChange: AvailabilityChange, services: [NetService]) {
      self.change = availabilityChange
      self.services = services
   }

   public let change: AvailabilityChange
   public let services: [NetService]
}
