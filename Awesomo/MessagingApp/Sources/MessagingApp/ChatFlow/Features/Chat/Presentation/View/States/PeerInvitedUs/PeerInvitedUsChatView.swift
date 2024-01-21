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
      onAcceptTapped: @escaping () -> Void,
      onDeclineTapped: @escaping () -> Void
   ) {
      self.displayModel = displayModel
      self.onAcceptTapped = onAcceptTapped
      self.onDeclineTapped = onDeclineTapped
   }

   let displayModel: PeerInvitedUsDisplayModel

   let onAcceptTapped: () -> Void
   let onDeclineTapped: () -> Void

   var body: some View {
      VStack() {
         Spacer()

         Text(displayModel.text)
            .font(.title)

         Spacer()

         HStack {
            Spacer()

            Button(action: onAcceptTapped) {
               Text(displayModel.acceptButtonTitle)
            }

            Spacer()

            Button(action: onDeclineTapped) {
               Text(displayModel.declineButtonTitle)
            }

            Spacer()
         }
      }
      .padding()
   }
}

#Preview {
   PeerInvitedUsChatView(
      PeerInvitedUsDisplayModel(
         text: "Spooky wants to chat",
         acceptButtonTitle: "Accept",
         declineButtonTitle: "Decline"
      ),
      onAcceptTapped: {},
      onDeclineTapped: {}
   )
}
