//
//  MissingPeerChatView.swift
//
//
//  Created by Vova on 21.01.2024.
//

import SwiftUI

struct MissingPeerChatView: View {
   init(_ message: String) {
      self.message = message
   }

   let message: String

   var body: some View {
      HStack {
         Text(message)
            .font(.title)
            .foregroundStyle(Color(white: 0.1))

         Spacer()
      }
      .padding()
   }
}

#Preview {
   MissingPeerChatView("User is no longer available")
}
