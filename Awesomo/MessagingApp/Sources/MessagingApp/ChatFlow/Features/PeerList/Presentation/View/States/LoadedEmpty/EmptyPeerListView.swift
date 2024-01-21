//
//  EmptyPeerListView.swift
//
//
//  Created by Vova on 21.01.2024.
//

import SwiftUI

struct EmptyPeerListView: View {
   let messageTitle: String
   let messageDescription: String

   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         Text(messageTitle)
            .font(.title)
            .foregroundStyle(Color(white: 0.1))

         Text(messageDescription)
            .font(.body)
            .foregroundStyle(Color(white: 0.4))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
   }
}

#Preview {
   EmptyPeerListView(
      messageTitle: "Looks like no one's nearby",
      messageDescription: "Make sure that the two devices are connected to the same WiFi network."
   )
}
