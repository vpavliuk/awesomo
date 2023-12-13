//
//  Recorder.swift
//  Awesomo
//
//  Created by Vova on 13.12.2023.
//

import Combine
import Foundation
import MessagingApp

protocol Persistor {
   func save(_ data: Data) async
}

final class Recorder: Middleman {
   init(persistor: Persistor = LocalPersistor()) {
      self.persistor = persistor
   }

   typealias Event = any InputEvent

   lazy var input: some Subscriber<Event, Never> = inputInternal
   #warning("Retain cycle?")
   private lazy var inputInternal = Subscribers.Sink<Event, Never>(
      receiveCompletion: { _ in },
      receiveValue: handleAppInput
   )

   lazy var output: some Publisher<Event, Never> = outputInternal
   private lazy var outputInternal = PassthroughSubject<Event, Never>()

   private func handleAppInput(_ input: any InputEvent) {
      outputInternal.send(input)
      queue.async { [weak self] in
         guard let self else { return }
         let timestamp = Date()
         let interval: TimeInterval = self.storedEvents.isEmpty
            ? .zero
            : timestamp.timeIntervalSince(self.latestEventTimestamp)
         self.latestEventTimestamp = timestamp
         let storedEvent = StoredEvent(appEvent: input, timeSincePrevious: interval)
         self.storedEvents.append(storedEvent)
         self.dumpEvents()
      }
   }

   private func dumpEvents() {
      guard let data = try? JSONEncoder().encode(storedEvents) else {
         return
      }
      Task {
         await persistor.save(data)
      }
   }

   private var storedEvents: [StoredEvent] = []
   private var latestEventTimestamp = Date()
   private let queue = DispatchQueue(label: "recordingMan-queue", qos: .utility)
   private let persistor: Persistor
}
