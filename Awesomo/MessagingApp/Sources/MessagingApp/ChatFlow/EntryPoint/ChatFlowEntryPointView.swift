//
//  ChatFlowEntryPointView.swift
//
//
//  Created by Vova on 10.01.2024.
//

import SwiftUI

struct ChatFlowEntryPointView: View {

   @StateObject
   var router: ChatRouter = ChatFlowFactory.getRouter()

   var body: some View {
      ChatFlowNavigationView(router: router)
   }
}
