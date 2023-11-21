//
//  XCTestCaseExtensions.swift
//  TestUtils
//
//  Created by Volodymyr Pavliuk on 03.09.2021.
//

import XCTest
import Combine

extension XCTestCase {
   public func expectLater<P: Publisher>(
      _ publisher: P,
      output: [P.Output],
      timeout: TimeInterval = 1,
      file: StaticString = #file,
      line: UInt = #line
   ) where P.Output: Equatable {

      var actualOutput: [P.Output] = []
      let expectation = expectation(description: "Awaiting publisher")

      let cancellable = publisher.sink(
         receiveCompletion: { _ in
            expectation.fulfill()
         },
         receiveValue: { value in
            actualOutput.append(value)
         }
      )

      wait(for: [expectation], timeout: timeout)
      cancellable.cancel()

      XCTAssertEqual(actualOutput, output, file: file, line: line)
   }

   public func expectNever(
      _ publisher: some Publisher,
      timeout: TimeInterval = 1,
      file: StaticString = #file,
      line: UInt = #line
   ) {
      let expectation = expectation(description: "Awaiting publisher")

      let cancellable = publisher.sink(
         receiveCompletion: { _ in
            expectation.fulfill()
         },
         receiveValue: { _ in
            XCTFail("Publisher did emit unexpectedly", file: file, line: line)
         }
      )

      wait(for: [expectation], timeout: timeout)
      cancellable.cancel()
   }
}
