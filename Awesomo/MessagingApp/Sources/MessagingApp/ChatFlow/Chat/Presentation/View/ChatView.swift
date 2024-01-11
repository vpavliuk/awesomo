//
//  ChatView.swift
//
//
//  Created by Vova on 20.12.2023.
//

import SwiftUI

struct ChatView: View {
   let peerName: String

   var body: some View {
      Text(peerName).navigationTitle(peerName)
   }
}

#Preview {
   ChatView(peerName: "Steve")
}
