//
//  Errors.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 15.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

enum CoreMessagingError: Error {
   case invalidArgument(arg: Any)
   case stub
}

extension CoreMessagingError: Equatable {
   static func ==(lhs: CoreMessagingError, rhs: CoreMessagingError) -> Bool {
      switch (lhs, rhs) {
      case (.invalidArgument(arg: _), .invalidArgument(arg: _)):
         return true
      case (.stub, .stub):
         return true
      default:
         return false
      }
   }
}
