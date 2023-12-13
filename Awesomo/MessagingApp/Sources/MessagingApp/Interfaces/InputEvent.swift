//
//  InputEvent.swift
//  MessagingApp
//
//  Created by Vova on 10.11.2023.
//

public protocol InputEvent: Codable {}

public enum CommonInput: InputEvent { case initial }
