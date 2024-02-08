import XCTest
import Transport
import TCPTransfer
import Domain
import Combine

final class TransportTest: XCTestCase {
   var sut: Transport!
   var mockTCPClient: TCPClientProtocol!

   override func setUp() {
      mockTCPClient = TCPClientMock()
      sut = Transport(tcpClient: mockTCPClient)
   }

   func testSendInvitationEroor() {
      let subject = PassthroughSubject<[Peer.Snapshot], Never>()
      let prefix = [
         [Peer.peer(name: "b")],
         [Peer.peer(name: "c")],
         [Peer.peer(name: "d")],
      ]
      let input1 = Publishers.Concatenate(prefix: prefix.publisher, suffix: subject)
      let input = Publishers.Concatenate(
         prefix: Just([Peer.peer(name: "b")]),
         suffix: input1.delay(for: 3.0, scheduler: RunLoop.main, options: .none)
      )

      let x = expectation(description: "Callback")
      let s = sut.output.sink { _ in
         subject.send([Peer.Snapshot(peerID: Peer.ID(value: ""), status: .online, relation: .stranger, name: "e", networkAddress: NetworkAddress(value: "123"), incomingMessages: [], outgoingMessages: [])])
         //x.fulfill()
      }
      input.subscribe(sut.input)

      waitForExpectations(timeout: 1000)

   }
}

private extension Peer{
   static func peer(name: String) -> Peer.Snapshot {
      Peer.Snapshot(peerID: Peer.ID(value: ""), status: .online, relation: .invitationInitiatedByUs, name: name, networkAddress: NetworkAddress(value: "123"), incomingMessages: [], outgoingMessages: [])
   }
}

final class TCPClientMock: TCPClientProtocol {
   func upload(_ upload: Upload) async throws {
      throw TCPTransferError.failedSending(upload.id, nil)
   }
}
