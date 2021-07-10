//
//  AppState+Equatable.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 02.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging

extension AppState: Equatable where
      ConcretePeer: Equatable,
      ConcreteMessage: Equatable,
      ConcreteMessage.Payload: Equatable {

   public static func ==(lhs: AppState, rhs: AppState) -> Bool {

      return lhs.localPeerId == rhs.localPeerId
            && lhs.selectedPeerId == rhs.selectedPeerId
            && lhs.peersState == rhs.peersState
            && lhs.incomingState == rhs.incomingState
            && lhs.outgoingState == rhs.outgoingState
   }
}
