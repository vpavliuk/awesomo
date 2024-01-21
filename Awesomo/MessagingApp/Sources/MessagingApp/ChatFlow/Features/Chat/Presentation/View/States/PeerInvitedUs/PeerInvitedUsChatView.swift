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

         Text(displayModel.text)
            .font(.title)
            .multilineTextAlignment(.center)

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
         text: "Spooky wants to chat. Accept their request?",
         acceptButtonTitle: "Accept"
      ),
      onAcceptTapped: {}
   )
}
