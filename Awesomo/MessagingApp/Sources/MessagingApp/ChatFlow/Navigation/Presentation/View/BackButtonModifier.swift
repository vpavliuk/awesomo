//
//  BackButtonModifier.swift
//
//
//  Created by Vova on 12.01.2024.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
   let title: String
   let onTap: () -> Void

   func body(content: Content) -> some View {
      content
         .navigationBarBackButtonHidden(true)
         .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Button {
                  onTap()
               } label: {
                  HStack {
                     Image(systemName: "chevron.backward")
                     Text(title)
                  }
               }
            }
         }
   }
}

extension View {
   func customBackButton(title: String, onTap: @escaping () -> Void) -> some View {
      modifier(BackButtonModifier(title: title, onTap: onTap))
   }
}
