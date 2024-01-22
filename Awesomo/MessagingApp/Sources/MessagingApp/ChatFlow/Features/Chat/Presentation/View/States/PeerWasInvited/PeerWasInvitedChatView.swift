//
//  PeerWasInvitedChatView.swift
//
//
//  Created by Vova on 22.01.2024.
//

import SwiftUI

struct PeerWasInvitedChatView: View {
   init(_ message: String) {
      self.message = message
   }

   let message: String

   var body: some View {
      HStack {
         Text(message)
            .font(.title3)
            .foregroundStyle(Color(white: 0.1))

         Spacer()
      }
      .padding()
   }
}

#Preview {
   PeerWasInvitedChatView("Waiting for the user to accept the invitation…")
}
