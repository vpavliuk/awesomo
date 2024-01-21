//
//  MissingPeerChatView.swift
//
//
//  Created by Vova on 21.01.2024.
//

import SwiftUI

struct MissingPeerChatView: View {
   let text: String

   var body: some View {
      Text(text)
         .font(.title)
         .multilineTextAlignment(.center)
   }
}
