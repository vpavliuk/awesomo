//
//  TCPUpload+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//

import TransportAdapter

extension TCPUpload: Equatable {
   public static func == (lhs: TCPUpload, rhs: TCPUpload) -> Bool {
      #warning("Use matchers instead of broken equality")
      return lhs.receiverServiceName == rhs.receiverServiceName &&
            lhs.message == rhs.message
   }
}
