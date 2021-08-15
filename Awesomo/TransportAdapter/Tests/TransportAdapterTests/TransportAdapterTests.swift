import XCTest
import Combine
import TransportAdapter
import MessagingApp
import Domain
import Utils

final class CoreMessagingTest: XCTestCase {
   var sut: TransportAdapter!
   var tcpTransfer: TCPTransferMock!

   override func setUp() {
      sut = TransportAdapter()
      sut.wireUp()

      tcpTransfer = TCPTransferMock()
      tcpTransfer.wireUp()

      sut.tcpInterface.connect(to: tcpTransfer.interface)
   }

//   func testSendOneChatMessageSuccessfully() {
//      let m = ChatMessage()
//      let publisher = PassthroughSubject<Message, Never>()
//      publisher.receive(subscriber: sut.appInterface.input)
//      sut.appInterface.output.sink { mes in
//         print(mes.id.value)
//      }
//      let expectation = expectation(description: "Expectation for output")
//
//      publisher.send(m)
//      wait(for: [expectation], timeout: 0.01)
//   }

//   func testSendChatRequestSuccess() {
//      // Arrange
//      let r = SendRequest(
//         receiver: "best_friend",
//         message: .chatRequest(ChatRequest())
//      )
//
//      let appOutput = PassthroughSubject<SendRequest, Never>()
//      appOutput.subscribe(sut.appInterface.input)
//
//      let e = expectation(description: "Expectation for TCP Out")
//      let tcpInput = PassthroughSubject<String, Never>()
//      let canceller2: AnyCancellable = sut.tcpInterface.output.subscribe(tcpInput)
//
//      let canceller = tcpInput
//         .map { $0 + "  ======================= Emitted ========================" }
//         .print()
//         .sink { s in e.fulfill() }
//
//
//      // Act
//      appOutput.send(r)
//
//      wait(for: [e], timeout: 0.01)
//      canceller2.cancel()
//      canceller.cancel()
//   }

   func testSendChatMessage() {
      // Arrange
      let r = SendRequest(
         receiver: "best_friend",
         message: .chatRequest(ChatRequest())
      )

      let appOutput = PassthroughSubject<SendRequest, Never>()
      appOutput.subscribe(sut.appInterface.input)

      let e = expectation(description: "Expectation for Transport Out")

      let subscription = sut.appInterface.output
         .map { transportOutput in
            switch transportOutput {
            case .incomingMessage:
               return "******* Message Received *******"
            case .sendSuccess(let reqId):
               return "******* Sent Successfully: \(reqId) *******"
            case .sendFailure(let reqId):
               return "******* Failed Sending: \(reqId) *******"
            }
         }
         .print()
         .sink { (s: String) in e.fulfill() }
      
      // Act
      appOutput.send(r)
      
      wait(for: [e], timeout: 2)
      subscription.cancel()
   }
}
