//
//  EntryPointView.swift
//
//
//  Created by Vova on 11.12.2023.
//

import SwiftUI

struct EntryPointView: View {
   @EnvironmentObject
   var app: MessagingApp<Data>

   var body: some View {
      PeerListView(
         vm: PeerListViewModel(domainSource: app.domainPublisher)
      )
   }
}
