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

         HStack(spacing: 8) {
            Button(action: onAcceptTapped) {
               Text(displayModel.acceptButtonTitle)
            }
            .disabled(displayModel.isAcceptButtonDisabled)

            if !displayModel.isProgressViewHidden {
               ProgressView()
            }
         }
      }
      .padding()
   }
}

#Preview("Initial") {
   PeerInvitedUsChatView(
      PeerInvitedUsDisplayModel(
         messageTitle: "Spooky wants to connect",
         messageDescription: "Spooky would like to share something with you. Accept their request?",
         acceptButtonTitle: "Accept",
         isAcceptButtonDisabled: false,
         isProgressViewHidden: true
      ),
      onAcceptTapped: {}
   )
}

#Preview("Accept tapped") {
   PeerInvitedUsChatView(
      PeerInvitedUsDisplayModel(
         messageTitle: "Spooky wants to connect",
         messageDescription: "Spooky would like to share something with you. Accept their request?",
         acceptButtonTitle: "Accept",
         isAcceptButtonDisabled: true,
         isProgressViewHidden: false
      ),
      onAcceptTapped: {}
   )
}
