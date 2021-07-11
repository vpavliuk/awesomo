//
//  ChatMessage.swift
//  AppliedMessaging
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

struct ChatMessage Hashable {
   let id = UUID()
   let timestamp = Date()
   let payload: String
}
