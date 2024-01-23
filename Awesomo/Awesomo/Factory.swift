//
//  Assembly.swift
//  Awesomo
//
//  Created by Vova on 28.11.2023.
//

import Combine
import Foundation
import PeerDiscovery
import BonjourBrowser
import TCPTransfer
import MessagingApp
import UIKit

enum Factory {

   static func getApp(middleman: (some Middleman<any InputEvent>)?) -> MessagingApp<Data> {

      let app: MessagingApp<Data> = CommonFactory.buildApp(appUserID: localUserID)
      app.wireUp()

      let appInputSource: some Publisher<any InputEvent, Never> = peerDiscovery.output
         .asAnyInput()
         .merge(with: app.userInputSink.asAnyInput())
         .merge(with: Just(CommonInput.initial).asAnyInput())

      if let middleman {
         middleman.output.subscribe(app.input)
         appInputSource.subscribe(middleman.input)
      } else {
         appInputSource.subscribe(app.input)
      }

      bonjourBrowser.output.subscribe(peerDiscovery.input)
      #warning("Test delayed startDiscovery")
      bonjourBrowser.startDiscovery()

      return app
   }

   private static let localUserID = UIDevice.current.identifierForVendor!.uuidString
   private static let localUserName = "User \(Int.random(in: 0...1000))"
   private static let localServiceName = getBonjourNameComposer().serviceName(
      fromIdString: localUserID,
      peerName: localUserName
   )

   private static let serviceType: String = {
      let serviceTypes = Bundle.main.object(forInfoDictionaryKey: "NSBonjourServices") as! [String]
      return serviceTypes.first!
   }()

   private static func getBonjourNameComposer() -> BonjourNameComposer { BonjourNameComposer() }

   private static let peerDiscovery: PeerDiscovery = {
      let peerDiscovery = PeerDiscovery(bonjourNameComposer: getBonjourNameComposer())
      peerDiscovery.wireUp()
      return peerDiscovery
   }()

   private static let bonjourBrowser = BonjourBrowser(serviceType: serviceType)

   private static let tcpTransfer: TCPTransfer = {
      let tcpTransfer = TCPTransfer(
         localServiceName: localServiceName,
         serviceType: serviceType
      )
      try! tcpTransfer.wireUp()
      return tcpTransfer
   }()
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
