//
//  MessageIDGeneratorMock.swift
//  
//
//  Created by Volodymyr Pavliuk on 30.03.2022.
//

@testable import TransportAdapter

final class MessageIDGeneratorMock: TransportAdapterMessageIDGenerator {
   func tcpOutputID(seqNumber: Int) -> TCPUpload.ID {
      if let existingID = uploadIDsPerSeqNumber[seqNumber] {
         return existingID
      }

      let id = TCPUpload.ID()
      uploadIDsPerSeqNumber[seqNumber] = id
      return id
   }

   private var uploadIDsPerSeqNumber: [Int: TCPUpload.ID] = [:]
}
