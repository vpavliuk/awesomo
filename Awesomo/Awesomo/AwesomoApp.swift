//
//  AwesomoApp.swift
//  Awesomo
//
//  Created by Volodymyr Pavliuk on 09.07.2021.
//

import SwiftUI

@main
struct AwesomoApp: App {

   @StateObject
   var app = Factory.getApp(middleman: nil as Recorder?)

   var body: some Scene {
      WindowGroup {
         app.makeEntryPointView()
      }
   }
}
