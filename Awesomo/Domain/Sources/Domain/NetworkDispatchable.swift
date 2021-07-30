//
//  NetworkDispatchable.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine

public protocol NetworkDispatchable {
   static var contentType: String { get }
   #warning("What about errors?")
   var tcpChunks: AnyPublisher<Data, Never> { get }
}
