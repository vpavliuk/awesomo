//
//  TransportAdapterMessageIDGenerator.swift
//  
//
//  Created by Volodymyr Pavliuk on 30.03.2022.
//

protocol TransportAdapterMessageIDGenerator {
   func tcpOutputID(seqNumber: Int) -> TCPUpload.ID
}
