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
      _peerListViewModel = StateObject(wrappedValue:  ChatFactory.getPeerListViewModel(router: router))
      _destinationViewProvider = StateObject(wrappedValue: ChatFactory.getDestinationProvider(router: router))
   }

   @ObservedObject
   var router: ChatRouter

   @StateObject
   var peerListViewModel: PeerListViewModel

   @StateObject
   var destinationViewProvider: ChatViewProvider

   var body: some View {
      NavigationStack(path: $router.path) {
         PeerListView()
            .environmentObject(peerListViewModel)
            .environmentObject(destinationViewProvider)
      }
   }
}
