import XCTest
import Combine
import MessagingApp
import Domain
import Utils
import TestUtils
import Foundation

@testable import TransportAdapter

final class TransportAdapterTests: XCTestCase {
   typealias TCPElement = UInt8
   typealias SendRequestFromApp = TransportSendRequest<String, TCPElement>

   var sut: TransportAdapter!
   var inputFromApp: PassthroughSubject<SendRequestFromApp, Never>!
   var tcpTransfer: TCPTransferMock!
   var sutTCPOutputStorage: InMemoryTestEventStorage<TCPUpload>!
   var messageIDGenerator: TransportAdapterMessageIDGenerator!
   let peer = "test_peer"

   override func setUp() {
      messageIDGenerator = MessageIDGeneratorMock()
      sut = TransportAdapter(messageIDGenerator: messageIDGenerator)
      sut.wireUp()

      tcpTransfer = TCPTransferMock()
      tcpTransfer.wireUp()

      sutTCPOutputStorage = InMemoryTestEventStorage()
      sut.tcpInterface.startSavingOutput(in: sutTCPOutputStorage)
      sut.tcpInterface.connect(to: tcpTransfer.interface)

      inputFromApp = PassthroughSubject()
      inputFromApp.subscribe(sut.appInterface.input)
   }

   override func tearDown() {
      weak var weakSut = sut
      sut = nil
      XCTAssertNil(weakSut)
   }

   func testDoingNothing() {}

   func testSendChatRequestSuccess() {
      // Arrange
      tcpTransfer.predefinedSendResult = .success
      let request = SendRequestFromApp(receiver: peer, message: .chatRequest)
      let expectedSendResult: OutputForApp.SendResult = .success(request.id)
      let expectedAppOutputEvent = OutputForApp.sendResult(expectedSendResult)
      let expectedTCPOutputEvent = TCPUpload(
         id: messageIDGenerator.tcpOutputID(seqNumber: 0),
         receiverServiceName: peer,
         message: Data()
      )

      // Act
      inputFromApp.send(request)
      inputFromApp.send(completion: .finished)

      // Assert
      sutTCPOutputStorage.expectEvents([expectedTCPOutputEvent])
      expectLater(sut.appInterface.output, output: [expectedAppOutputEvent])
   }

   func testSendChatRequestFailure() {
      // Arrange
      tcpTransfer.predefinedSendResult = .failure
      let request = SendRequestFromApp(receiver: peer, message: .chatRequest)
      let sendError = OutputForApp.SendError(requestID: request.id)
      let expectedSendResult: OutputForApp.SendResult = .failure(sendError)
      let expectedAppOutputEvent = OutputForApp.sendResult(expectedSendResult)
      let expectedTCPOutputEvent = TCPUpload(
         id: messageIDGenerator.tcpOutputID(seqNumber: 0),
         receiverServiceName: peer,
         message: Data()
      )

      // Act
      inputFromApp.send(request)
      inputFromApp.send(completion: .finished)

      // Assert
      sutTCPOutputStorage.expectEvents([expectedTCPOutputEvent])
      expectLater(sut.appInterface.output, output: [expectedAppOutputEvent])
   }

   func testSendMessageSuccess() {
      // Arrange
      var collectedData = Data()
      let messageContent = TestPlainText(text: "Test Message").eraseToAny()
      let chatMessage = ChatMessage(content: messageContent)
      let request = SendRequestFromApp(
         receiver: peer,
         message: .chatMessage(chatMessage)
      )
      let expectedSendResult: OutputForApp.SendResult = .success(request.id)
      let expectedAppOutputEvent = OutputForApp.sendResult(expectedSendResult)
      let dataExpectation = expectation(description: "Expectation for content data")
      let sub = messageContent.networkPublisher.sink { _ in
         dataExpectation.fulfill()
      } receiveValue: { element in
         collectedData.append(element)
      }
      wait(for: [dataExpectation], timeout: 0.01)
      sub.cancel()
      let expectedTCPOutputEvent = TCPUpload(
         id: messageIDGenerator.tcpOutputID(seqNumber: 0),
         receiverServiceName: peer,
         message: collectedData
      )

      // Act
      inputFromApp.send(request)
      inputFromApp.send(completion: .finished)

      // Assert
      expectLater(sut.appInterface.output, output: [expectedAppOutputEvent])
      expectLater(sut.tcpInterface.output, output: [expectedTCPOutputEvent])
   }
}

private struct TestPlainText: MessageContent {
   internal init(text: String) {
      self.text = text
      self.networkPublisher =
            text.data(using: .utf8)!.publisher.eraseToAnyPublisher()
   }

   typealias NetworkRepresentation = TransportAdapterTests.TCPElement
   let networkPublisher: AnyPublisher<NetworkRepresentation, Never>

   private let text: String
}
