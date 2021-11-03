//
//  InMemoryTestEventStorage.swift
//  TestUtils
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Utils
import Foundation
import XCTest

public final class InMemoryTestEventStorage<Event>: EventStorage where Event: Equatable {
   public init() {}

   public var events: [Event] {
      return accessQueue.sync { eventsInternal }
   }

   public var isComplete: Bool {
      return accessQueue.sync { isCompleteInternal }
   }

   public func add(_ event: Event) {
      accessQueue.sync(flags: .barrier) {
         eventsInternal.append(event)
      }
   }

   public func complete() {
      precondition(!isComplete)
      accessQueue.sync(flags: .barrier) { isCompleteInternal = true }
      expectation.fulfill()
   }

   public func expectEvents(
      _ expectedEvents: [Event],
      timeout: TimeInterval = 1,
      file: StaticString = #file,
      line: UInt = #line
   ) {
      guard !isComplete else {
         assertEqualEvents(expected: expectedEvents, file: file, line: line)
         return
      }

      let result = waiter.wait(for: [expectation], timeout: timeout)

      guard result == .completed else {
         XCTFail(
            "Waiting for completion timed out.",
            file: file,
            line: line
         )
         return
      }

      assertEqualEvents(expected: expectedEvents, file: file, line: line)
   }

   private func assertEqualEvents(expected: [Event], file: StaticString, line: UInt) {
      XCTAssertEqual(events, expected, file: file, line: line)
   }

   private var eventsInternal: [Event] = []
   private var isCompleteInternal = false
   private let expectation = XCTestExpectation()
   private let waiter = XCTWaiter()
   private let accessQueue = DispatchQueue(label: "InMemoryTestEventStorage access queue")
}
