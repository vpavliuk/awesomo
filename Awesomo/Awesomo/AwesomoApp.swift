//
//  AwesomoApp.swift
//  Awesomo
//
//  Created by Volodymyr Pavliuk on 09.07.2021.
//

import SwiftUI
import Combine
import Domain
import MessagingApp
import PeerDiscovery

@main
struct AwesomoApp: App {
   #warning("StateObject?")
   let app = buildApp(
      peerDiscoveryInput: PeerDiscoveryMock().output,
      middleman: Player()
   )

   var body: some Scene {
      WindowGroup {
         app.makeEntryPointView()
      }
   }
}
