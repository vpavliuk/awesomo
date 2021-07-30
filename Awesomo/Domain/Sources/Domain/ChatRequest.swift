//
//  ChatRequest.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

public struct ChatRequest {
   public init() {}
}

//extension ChatRequest: NetworkDispatchable {
//   static let contentType = "chat/request"
//   
//   var tcpChunks: AnyPublisher<Data, Never> {
//      Just(try! JSONEncoder().encode(peerId)).eraseToAnyPublisher()
//   }
//   
//   
//}
