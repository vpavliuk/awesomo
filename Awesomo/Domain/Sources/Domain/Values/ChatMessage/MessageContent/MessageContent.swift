//
//  MessageContent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine

public protocol MessageContentReserved<NetworkRepresentationElement> {
   associatedtype NetworkRepresentationElement

   #warning("Potential violation of Single Responsibility")
   #warning("Don't forget about errors")
   var networkPublisher: AnyPublisher<NetworkRepresentationElement, Never> { get }
}

public struct MessageContent {
   public struct ContentID: Hashable {
      private let value: String
   }
   public let contentID: ContentID
   public let dataPublisher: AnyPublisher<Data, Never> = "Hello"
      .data(using: .utf8)
      .publisher
      .eraseToAnyPublisher()
}
