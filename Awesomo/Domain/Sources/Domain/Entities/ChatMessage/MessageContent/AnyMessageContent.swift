//
//  AnyMessageContent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public struct AnyMessageContent<NetworkRepresentationElement>: MessageContent {

   public init<Base: MessageContent>(_ base: Base)
         where Base.NetworkRepresentationElement == NetworkRepresentationElement {

      networkPublisher = base.networkPublisher
   }

   public let networkPublisher: AnyPublisher<NetworkRepresentationElement, Never>
}

public extension MessageContent {
   func eraseToAny() ->
         AnyMessageContent<NetworkRepresentationElement> { AnyMessageContent(self) }
}
