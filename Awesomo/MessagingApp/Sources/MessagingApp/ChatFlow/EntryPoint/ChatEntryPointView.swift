//
//  ChatEntryPointView.swift
//
//
//  Created by Vova on 10.01.2024.
//

import SwiftUI

struct ChatEntryPointView: View {

   @StateObject
   var router: ChatRouter = ChatFactory.getRouter()

   var body: some View {
      ChatFlowNavigationView(router: router)
   }
}
