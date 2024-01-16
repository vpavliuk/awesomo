//
//  ChatEntryPointView.swift
//
//
//  Created by Vova on 10.01.2024.
//

import SwiftUI

struct ChatEntryPointView: View {
   @EnvironmentObject
   var viewModelBuilder: ViewModelBuilder

   #warning("Re-factor for nicer dependency injection")
   var body: some View {
      ChatNavigationView()
         .environmentObject(ChatFactory.router)
         .environmentObject(ChatFactory.getDestinationProvider())
         .environmentObject(viewModelBuilder.buildInteractiveViewModel(of: PeerListViewModel.self,
            userInputHandler: ChatFactory.peerListUserInputHandler
         ))
   }
}

private struct ChatNavigationView: View {

   @EnvironmentObject
   var peerListViewModel: PeerListViewModel

   @EnvironmentObject
   var router: ChatRouter

   var body: some View {
      NavigationStack(path: $router.path) {
         PeerListView(vm: peerListViewModel)
      }
   }
}
