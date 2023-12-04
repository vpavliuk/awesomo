//
//  InputHandler.swift
//  
//
//  Created by Vova on 02.12.2023.
//

protocol InputHandler<Event> {
   associatedtype Event: InputEvent
   func on(_ event: Event)
}
