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

   @StateObject
   var app = buildApp(
      peerDiscoveryInput: PeerDiscoveryMock().output,
      middleman: Recorder()
   )

   var body: some Scene {
      WindowGroup {
         app.makeEntryPointView()
      }
   }
}
