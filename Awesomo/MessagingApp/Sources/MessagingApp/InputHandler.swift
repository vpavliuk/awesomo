//
//  InputHandler.swift
//  
//
//  Created by Vova on 02.12.2023.
//

import Domain

protocol InputHandler<Event> {
   associatedtype Event: InputEvent
   func on(_ event: Event)
}
