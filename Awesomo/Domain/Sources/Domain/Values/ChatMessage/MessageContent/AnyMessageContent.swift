//
//  AnyMessageContent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public struct AnyMessageContent<NetworkRepresentationElement>: MessageContentReserved {

   public init<Base: MessageContentReserved>(_ base: Base)
         where Base.NetworkRepresentationElement == NetworkRepresentationElement {

      networkPublisher = base.networkPublisher
   }

   public let networkPublisher: AnyPublisher<NetworkRepresentationElement, Never>
}

public extension MessageContentReserved {
   func eraseToAny() ->
         AnyMessageContent<NetworkRepresentationElement> { AnyMessageContent(self) }
}
