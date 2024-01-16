//
//  ChatEntryPointView.swift
//
//
//  Created by Vova on 10.01.2024.
//

import SwiftUI

struct ChatEntryPointView: View {
   var body: some View {
      ChatNavigationView()
         .environmentObject(ChatFactory.router)
   }
}

private struct ChatNavigationView: View {
   @EnvironmentObject
   var viewModelBuilder: ViewModelBuilder

   @EnvironmentObject
   var router: ChatRouter

   var body: some View {
      NavigationStack(path: $router.path) {
         PeerListView(
            vm: viewModelBuilder.buildInteractiveViewModel(
               userInputHandler: ChatFactory.peerListUserInputHandler
            )
         )
         .environmentObject(ChatFactory.destinationProvider)
      }
   }
}
