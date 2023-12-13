//
//  Player.swift
//  Awesomo
//
//  Created by Vova on 13.12.2023.
//

import MessagingApp
import Combine
import Foundation

final class Player: Middleman {
   init() {
      #warning("Retain cycles?")
      queue.async {
         self.storedEvents = try! JSONDecoder()
            .decode([StoredEvent].self, from: Data(contentsOf: self.pathToStore))
         DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5,
            execute: self.playNextEvent
         )
      }
   }

   typealias Event = any InputEvent

   lazy var input: some Subscriber<Event, Never> = inputInternal
   private let inputInternal = Subscribers.Sink<Event, Never>(
      receiveCompletion: { _ in },
      receiveValue: { _ in }
   )

   lazy var output: some Publisher<Event, Never> = outputInternal
   private let outputInternal: some Subject<Event, Never> = PassthroughSubject()

   private func playNextEvent() {
      guard let current = storedEvents.first,
            let appEvent = current.decodeAppEvent() else {
         return
      }

      outputInternal.send(appEvent)
      storedEvents = Array(storedEvents.dropFirst())
      if let next = storedEvents.first {
         DispatchQueue.main.asyncAfter(
            deadline: .now() + next.timeSincePrevious,
            execute: playNextEvent
         )
      }
   }
   
   private var storedEvents: [StoredEvent] = []
   
   private let queue = DispatchQueue(label: "playbackMan-queue", qos: .utility)
   private let pathToStore = URL(fileURLWithPath: "/Users/cort/Desktop/store")
   //    var pathToStore: URL {
   //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
   //        return paths.first!
   //    }
}
