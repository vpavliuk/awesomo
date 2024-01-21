//
//  PeerInvitedUsChatView.swift
//
//
//  Created by Vova on 21.01.2024.
//

import SwiftUI

struct PeerInvitedUsChatView: View {
   init(
      _ displayModel: PeerInvitedUsDisplayModel,
      onAcceptTapped: @escaping () -> Void
   ) {
      self.displayModel = displayModel
      self.onAcceptTapped = onAcceptTapped
   }

   let displayModel: PeerInvitedUsDisplayModel
   let onAcceptTapped: () -> Void

   var body: some View {
      VStack() {
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

         Button(action: onAcceptTapped) {
            Text(displayModel.acceptButtonTitle)
         }
      }
      .padding()
   }
}

#Preview {
   PeerInvitedUsChatView(
      PeerInvitedUsDisplayModel(
         messageTitle: "Spooky wants to chat",
         messageDescription: "Spooky would like to connect. Accept their request?",
         acceptButtonTitle: "Accept"
      ),
      onAcceptTapped: {}
   )
}
