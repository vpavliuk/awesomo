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
    peerDiscoveryInput: some Publisher<PeerAvailabilityEvent, Never>,
    peerListUserInput: some Publisher<PeerListUserInput, Never>,
    middleman: (some Middleman<any InputEvent>)?
) -> MessagingApp<Data> {

   let appInputSource: some Publisher<any InputEvent, Never> = peerDiscoveryInput.asAnyAppInput()
      //.merge(with: peerListUserInput.asAnyAppInput())
      .merge(with: Just(CommonInput.initial).asAnyAppInput())

   let app = MessagingApp<Data>()
   app.wireUp()

   if let middleman {
      middleman.output.subscribe(app.input)
      appInputSource.subscribe(middleman.input)
   } else {
      appInputSource.subscribe(app.input)
   }

   return app
}

private extension Publisher where Output: InputEvent {
   func asAnyAppInput() -> some Publisher<any InputEvent, Failure> {
      return map { $0 as any InputEvent }
   }
}
