//
//  Middleman.swift
//  Awesomo
//
//  Created by Vova on 28.11.2023.
//

import Combine

protocol Middleman<Event> {
   associatedtype Event
   associatedtype InputSink: Subscriber<Event, Never>
   var input: InputSink { get }

   associatedtype OutputSource: Publisher<Event, Never>
   var output: OutputSource { get }
}
