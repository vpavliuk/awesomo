//
//  NavigationRouter.swift
//
//
//  Created by Vova on 23.12.2023.
//

import SwiftUI

protocol NavigationRouter: ObservableObject {
   associatedtype Entity
   func push(_ entity: Entity)
   func pop()
}
