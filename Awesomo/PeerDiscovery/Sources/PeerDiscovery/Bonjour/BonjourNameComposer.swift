//
//  BonjourNameComposer.swift
//  Peer Discovery
//
//  Created by Volodymyr Pavliuk on 25.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Domain

public protocol BonjourNameComposer {
   func peerAttributesFromServiceName(_ name: String)
         -> (id: Peer<String>.ID, displayName: String)
}
