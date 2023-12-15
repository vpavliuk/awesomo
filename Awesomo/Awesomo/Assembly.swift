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
    middleman: (some Middleman<any InputEvent>)?
) -> MessagingApp<Data> {

   let app = MessagingApp<Data>()
   app.wireUp()

   let appInputSource: some Publisher<any InputEvent, Never> = peerDiscoveryInput.asAnyInput()
      .merge(with: app.userInputSink.asAnyInput())
      .merge(with: Just(CommonInput.initial).asAnyInput())

   if let middleman {
      middleman.output.subscribe(app.input)
      appInputSource.subscribe(middleman.input)
   } else {
      appInputSource.subscribe(app.input)
   }

   return app
}

private extension Publisher where Output: InputEvent {
   func asAnyInput() -> some Publisher<any InputEvent, Failure> { map(\.asAnyInput) }
}

private extension Publisher where Output == any UserInput {
   func asAnyInput() -> some Publisher<any InputEvent, Failure> { map(\.asAnyInput) }
}

private extension InputEvent {
   var asAnyInput: any InputEvent { self }
}
