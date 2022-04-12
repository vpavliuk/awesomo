import XCTest
import Combine
import MessagingApp
import Domain
import Utils
import TestUtils

@testable import TransportAdapter

final class TransportAdapterTests: XCTestCase {
   var sut: TransportAdapter!
   var inputFromApp: PassthroughSubject<TransportSendRequest<String>, Never>!
   var tcpTransfer: TCPTransferMock!
   var sutTCPOutputStorage: InMemoryTestEventStorage<TCPUpload>!
   var messageIDGenerator: TransportAdapterMessageIDGenerator!

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

   func testSendChatRequestSuccess() {
      // Arrange
      let receiverName = "test_receiver"
      let request = TransportSendRequest(
         receiver: receiverName,
         message: .chatRequest(ChatRequest())
      )
      let expectedAppOutputEvent = TransportAdapter.OutputForApp.sendSuccess(request.id)
      let expectedTCPOutputEvent = TCPUpload(
         id: messageIDGenerator.tcpOutputID(seqNumber: 0),
         receiverServiceName: receiverName,
         message: .completeDomainMessage(
            DomainMessageTCPRepresentation(
               id: nil,
               messageType: .chatRequest,
               payload: Data()
            )
         )
      )

      // Act
      inputFromApp.send(request)
      inputFromApp.send(completion: .finished)

      // Assert
      sutTCPOutputStorage.expectEvents([expectedTCPOutputEvent])
      expectLater(sut.appInterface.output, output: [expectedAppOutputEvent])
   }
}
