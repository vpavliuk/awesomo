//
//  StrangerPeerChatView.swift
//  
//
//  Created by Vova on 21.01.2024.
//

import SwiftUI

struct StrangerPeerChatView: View {
   init(_ displayModel: StrangerPeerDisplayModel, onInvite: @escaping () -> Void) {
      self.displayModel = displayModel
      self.onInvite = onInvite
   }

   let displayModel: StrangerPeerDisplayModel
   let onInvite: () -> Void

   var body: some View {
      Button(action: onInvite) {
         Text(displayModel.inviteButtonTitle)
      }
   }
}
