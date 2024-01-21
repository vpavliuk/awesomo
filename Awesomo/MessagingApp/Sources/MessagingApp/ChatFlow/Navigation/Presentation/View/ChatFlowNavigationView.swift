//
//  ChatFlowNavigationView.swift
//
//
//  Created by Vova on 17.01.2024.
//

import SwiftUI

struct ChatFlowNavigationView: View {

   init(router: ChatRouter) {
      self.router = router
      _peerListViewModel = StateObject(wrappedValue:  PeerListFactory.getViewModel(router: router))
      _destinationViewProvider = StateObject(wrappedValue: ChatFlowFactory.getDestinationProvider(router: router))
   }

   @ObservedObject
   var router: ChatRouter

   @StateObject
   var peerListViewModel: PeerListViewModel

   @StateObject
   var destinationViewProvider: ChatFlowViewProvider

   var body: some View {
      NavigationStack(path: $router.path) {
         PeerListScreen()
            .environmentObject(peerListViewModel)
            .environmentObject(destinationViewProvider)
      }
   }
}
