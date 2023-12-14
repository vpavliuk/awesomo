//
//  PeerDiscoveryMock.swift
//  Awesomo
//
//  Created by Vova on 13.12.2023.
//

import MessagingApp
import Domain
import Combine
import Foundation

final class PeerDiscoveryMock {
   static var index = 0
   static var guys = [
      "I1",
      "K2",
      "B3",
      "K4"
   ]
   var subscription: AnyCancellable?
   let output: some Publisher<PeerAvailabilityEvent, Never> = Timer.publish(every: 150, on: .main, in: .default)
      .autoconnect()
      .map { _ in
         index += 1
         return PeerAvailabilityEvent.peersDidAppear(
            [
               Peer.ID(value: "John\(index)"): PeerEmergence(peerName: guys[index - 1], peerAddress: NetworkAddress(value: "1234\(index)"))
            ]
         )
      }
      //.receive(on: Dis)
      //.assign(to: \.lastUpdated, on: myDataModel)


}
