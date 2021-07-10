//
//  BonjourNameComposerTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 15.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class BonjourNameComposerTest: XCTestCase {
   typealias ConcreteComposer = BonjourNameComposer<TestPeer>
   var sut: ConcreteComposer!

   override func setUp() {
      super.setUp()
      sut = BonjourNameComposer()
   }

// MARK: -
   func testGetComponentsFromEmptyName() {
      let emptyName = ""
      XCTAssertThrowsError(
         try sut.components(fromName: emptyName),
         "Error should be thrown"
      ) { error in
         guard let coreError = error as? CoreMessagingError else {
            XCTFail("Error was thrown and that's fine, but the error type is wrong.")
            return
         }

         XCTAssertEqual(coreError, CoreMessagingError.invalidArgument(arg: "arbitrary"))
      }
   }

   func testGetComponentsFromInvalidName() {
      let invalidName = "Invalid name with only one component"
      XCTAssertThrowsError(try sut.components(fromName: invalidName))
   }

   func performComponentsTestFromValidName(
         _ name: String,
         expectedResult: (id: String, displayName: String)
   ) {
      do {
         let components = try sut.components(fromName: name)
         XCTAssertEqual(components.id, expectedResult.id)
         XCTAssertEqual(components.displayName, expectedResult.displayName)
      } catch {
         XCTFail("Error was thrown unexpectedly")
      }
   }

   func testGetComponentsFromExtremeShortName() {
      let shortName = String(ConcreteComposer.separator)
      performComponentsTestFromValidName(
         shortName,
         expectedResult: (
            id: "",
            displayName: ""
         )
      )
   }

   func testGetComponentsFromUnusualName() {
      performComponentsTestFromValidName(
         "~id...",
         expectedResult: (
            id: "~id",
            displayName: ".."
         )
      )
   }

   func testGetComponentsFromRegularName() {
      let uuid = "dcb31f0c-f4b4-4aef-819d-d1de943f0826"
      let display = "Awesome User!"
      performComponentsTestFromValidName(
         uuid + "." + display,
         expectedResult: (
            id: uuid,
            displayName: display
         )
      )
   }

// MARK: -
   func testGetNameFromEmptyComponents() {
      let name: String = sut.name(fromId: "", displayName: "")
      XCTAssertEqual(name, String(ConcreteComposer.separator))
   }

   func testGetNameFromComponents() {
      let id = "some id"
      let displayName = "Mega User"
      let name: String = sut.name(fromId: id, displayName: displayName)
      XCTAssertEqual(name, id + String(ConcreteComposer.separator) + displayName)
   }
}
