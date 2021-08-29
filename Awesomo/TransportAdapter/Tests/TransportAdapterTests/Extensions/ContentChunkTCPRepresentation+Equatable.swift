//
//  ContentChunkTCPRepresentation+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//

import TransportAdapter

extension ContentChunkTCPRepresentation: Equatable {
   public static func == (lhs: ContentChunkTCPRepresentation, rhs: ContentChunkTCPRepresentation) -> Bool {
      return lhs.contentType == rhs.contentType && lhs.payload == rhs.payload
   }
}
