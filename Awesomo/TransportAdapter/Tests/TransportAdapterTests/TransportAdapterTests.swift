import XCTest
import Combine
import TransportAdapter
import MessagingApp
import Domain
import Utils
import TestUtils

final class TransportAdapterTests: XCTestCase {
   var sut: TransportAdapter!
   var appOutput: PassthroughSubject<TransportSendRequest<String>, Never>!
   var tcpTransfer: TCPTransferMock!
   var sutTCPOutputStorage: InMemoryTestEventStorage<TCPUpload>!

   override func setUp() {
      sut = TransportAdapter()
      sut.wireUp()

      tcpTransfer = TCPTransferMock()
      tcpTransfer.wireUp()

      sutTCPOutputStorage = InMemoryTestEventStorage()
      sut.tcpInterface.startSavingOutput(in: sutTCPOutputStorage)
      sut.tcpInterface.connect(to: tcpTransfer.interface)

      appOutput = PassthroughSubject()
      appOutput.subscribe(sut.appInterface.input)
   }

   func testSendChatRequestSuccess() {
      // Arrange
      let request = TransportSendRequest(
         receiver: "test_receiver",
         message: .chatRequest(ChatRequest())
      )
      let expectedAppOutputEvent = InputFromTransport.sendSuccess(request.id)
      let expectedTCPOutputEvent = TCPUpload(
         receiverServiceName: "test_receiver",
         message: .completeDomainMessage(
            DomainMessageTCPRepresentation(
               id: nil,
               messageType: .chatRequest,
               payload: Data()
            )
         )
      )

      // Act
      appOutput.send(request)
      appOutput.send(completion: .finished)

      // Assert
      sutTCPOutputStorage.expectEvents([expectedTCPOutputEvent])
      expectLater(sut.appInterface.output, output: [expectedAppOutputEvent])
   }
}
