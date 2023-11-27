//
//  InputEvent.swift
//  MessagingApp
//
//  Created by Vova on 10.11.2023.
//

import Foundation

public protocol InputEvent: Hashable {
   var timestamp: Date { get }
   var portID: String { get }
}
