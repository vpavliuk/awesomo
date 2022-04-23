//
//  MessageContent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public protocol MessageContent {
   associatedtype NetworkRepresentationElement

   #warning("Potential violation of Single Responsibility")
   #warning("Don't forget about errors")
   var networkPublisher: AnyPublisher<NetworkRepresentationElement, Never> { get }
}
