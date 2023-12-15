//
//  EntryPointView.swift
//
//
//  Created by Vova on 11.12.2023.
//

import SwiftUI

struct EntryPointView: View {
   @EnvironmentObject
   var app: ViewModelBuilder

   var body: some View {
      PeerListView(vm: app.buildViewModel())
   }
}
