//
//  AllEventTypes.swift
//  
//
//  Created by Vova on 22.12.2023.
//

internal let allEventTypes: [any InputEvent.Type] = [
   PeerAvailabilityEvent.self,
   PeerListUserInput.self,
   ChatFlowNavigationPop.self,
   CommonInput.self,
]
