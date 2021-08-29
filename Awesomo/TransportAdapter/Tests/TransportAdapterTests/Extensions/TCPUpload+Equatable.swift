//
//  TCPUpload+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//

import TransportAdapter

extension TCPUpload: Equatable {
   public static func == (lhs: TCPUpload, rhs: TCPUpload) -> Bool {
      return lhs.id == rhs.id &&
            lhs.receiverServiceName == rhs.receiverServiceName &&
            lhs.message == rhs.message
   }
}
