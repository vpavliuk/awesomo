//
//  ChatRequest+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 03.11.2021.
//

import Domain

extension ChatRequest: Equatable {
   #warning("Is ChatRequest necessary at all?")
   public static func == (_: ChatRequest, _: ChatRequest) -> Bool { true }
}
