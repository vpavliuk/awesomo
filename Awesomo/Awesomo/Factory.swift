//
//  Assembly.swift
//  Awesomo
//
//  Created by Vova on 28.11.2023.
//

import Combine
import Foundation
import Domain
import PeerDiscovery
import BonjourBrowser
import class TCPClient.TCPClient
import Transport
import TCPListener
import MessagingApp
import UIKit

extension TCPClient: Transport.TCPClient {}

enum Factory {

   static func getApp(middleman: (some Middleman<any MessagingApp.InputEvent>)?) -> App<Data, CoreMessenger.State> {
      let app: ConcreteApp = CommonFactory.buildApp(appUserID: localUserID)
      app.wireUp()

      let appInputSource = Just(CommonInput.initial)
         .asAnyInput()
         .merge(with: peerDiscoveryInput)
         .merge(with: getUserInput(app: app))
         .merge(
            with: getTransport(stateSource: app.stateSource)
               .output
               .asAnyInput()
         )


      if let middleman {
         middleman.output.subscribe(app.input)
         appInputSource.subscribe(middleman.input)
      } else {
         appInputSource.subscribe(app.input)
      }

      bonjourBrowser.startDiscovery()
      try! tcpListener.startListening()

      return app
   }

   private static let localUserID = UIDevice.current.identifierForVendor!.uuidString
   private static let localUserName = "iPhone user"
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
      bonjourBrowser.output.subscribe(peerDiscovery.input)
      return peerDiscovery
   }()

   private static var peerDiscoveryInput: some Publisher<any MessagingApp.InputEvent, Never> { peerDiscovery.output.asAnyInput() }

   private static func getUserInput(app: ConcreteApp)
         -> some Publisher<any MessagingApp.InputEvent, Never> { app.userInputSink.asAnyInput() }

   //private static let peerDiscovery = PeerDiscoveryMock()

   private static let bonjourBrowser = BonjourBrowser(serviceType: serviceType)

   private static func getTransport(stateSource: some Publisher<CoreMessenger.State, Never>) -> TransportProcessor {
      let transport = TransportProcessor(tcpClient: tcpClient, localUserID: Peer.ID(value: localUserID))
      transport.wireUp()
      stateSource.subscribe(transport.inputFromApp)
      tcpListener.output.subscribe(transport.inputFromNetwork)
      return transport
   }

   private static let tcpListener = TCPListener(serviceName: localServiceName, serviceType: serviceType)

   private static let tcpClient = TCPClient(bonjourServiceType: serviceType)

   private typealias ConcreteApp = App<Data, CoreMessenger.State>
}

private extension Publisher where Output: MessagingApp.InputEvent {
   func asAnyInput() -> some Publisher<any MessagingApp.InputEvent, Failure> { map(\.asAnyInput) }
}

private extension Publisher where Output == any UserInput {
   func asAnyInput() -> some Publisher<any MessagingApp.InputEvent, Failure> { map(\.asAnyInput) }
}

private extension MessagingApp.InputEvent {
   var asAnyInput: any MessagingApp.InputEvent { self }
}
