//
//  TCPClient.swift
//
//
//  Created by Vova on 30.01.2024.
//

import Foundation

public protocol TCPClient {
   func upload(_ data: Data, to networkAddress: String) async throws
}
