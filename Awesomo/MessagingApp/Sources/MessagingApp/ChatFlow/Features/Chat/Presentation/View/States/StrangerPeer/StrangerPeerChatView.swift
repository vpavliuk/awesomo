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
      VStack {
         Spacer()

         VStack(alignment: .leading, spacing: 8) {
            Text(displayModel.messageTitle)
               .font(.title)
               .foregroundStyle(Color(white: 0.1))
            Text(displayModel.messageDescription)
               .font(.body)
               .foregroundStyle(Color(white: 0.4))
         }
         .frame(maxWidth: .infinity, alignment: .leading)

         Spacer()

         Button(action: onInvite) {
            Text(displayModel.inviteButtonTitle)
         }
      }
      .padding()
   }
}

// MARK: - Previews

#Preview("Actual message") {
   StrangerPeerChatView(
      StrangerPeerDisplayModel(
         messageTitle: "Spooky is online!",
         messageDescription: "Invite them to a chat where you can share text, photos, and more.",
         inviteButtonTitle: "Invite"
      )
   ) {}
}

#Preview("Short message") {
   StrangerPeerChatView(
      StrangerPeerDisplayModel(
         messageTitle: "Spooky is online!",
         messageDescription: "Invite them.",
         inviteButtonTitle: "Invite"
      )
   ) {}
}
