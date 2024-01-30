import Network
import Foundation
import Combine

public final class TCPListener {

   public init(serviceName: String, serviceType: String) {
      self.serviceName = serviceName
      self.serviceType = serviceType
   }

   public func startListening() throws {
      listener = try NWListener(using: .tcp)
      listener.service = NWListener.Service(
         name: serviceName,
         type: serviceType
      )
      listener.newConnectionHandler = handleNewConnection
      listener.start(queue: queue)
   }

   public lazy var output: some Publisher<Data, Never> = outputInternal

   private let serviceName: String
   private let serviceType: String

   private let mtu = 65535

   private var listener: NWListener!
   private let queue = DispatchQueue(label: "com.vp.tcp-server-queue")

   private func handleNewConnection(_ connection: NWConnection) {
      connection.start(queue: queue)

      receive(on: connection) { (tcpData: Data?) in
         guard let tcpData = tcpData,
               let message = try? JSONDecoder().decode(Data.self, from: tcpData)
         else {
            #warning("Handle decoding errors")
            return
         }

         self.outputInternal.send(message)
      }
   }

   private func receive(
         on connection: NWConnection,
         intermediateResult: Data? = nil,
         completion: @escaping (Data?) -> Void
   ) {
      connection.receive(
         minimumIncompleteLength: 1,
         maximumLength: self.mtu
      ) { (chunk: Data?, _, isComplete, error: NWError?) in

         guard let chunk = chunk else {
            if isComplete {
               completion(intermediateResult)
            }
            #warning("Handle errors here")
            return
         }
         assert(!isComplete)

         var nextResult = intermediateResult ?? Data()
         nextResult.append(chunk)

         self.receive(
            on: connection,
            intermediateResult: nextResult,
            completion: completion
         )
      }
   }

   private let outputInternal = PassthroughSubject<Data, Never>()
}
