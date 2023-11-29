//
//  Assembly.swift
//  Awesomo
//
//  Created by Vova on 28.11.2023.
//

import Combine
import Foundation
import MessagingApp

func buildApp(
    peerDiscoveryInput: some Publisher<PeerAvailabilityEvent<String>, Never>,
    middleman: (some Middleman<InputEvent>)?
) -> MessagingApp<String, Data> {
   let appInput: some Publisher<InputEvent, Never> = peerDiscoveryInput
      .map { _ in T.one }

   let app = MessagingApp<String, Data>()

   if let middleman {
      appInput.subscribe(middleman.input)
      middleman.output.subscribe(app.input)
   } else {
      appInput.subscribe(app.input)
   }

   return app
}
