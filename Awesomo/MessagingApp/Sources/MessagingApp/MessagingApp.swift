import Utils
import Domain
import Combine

public struct MessagingApp<NetworkAddress> {
   public init() {
      transportInterfaceInternal = PassthroughTwoWayInterface()
      transportInterface = transportInterfaceInternal.eraseToAny()
   }

   public let transportInterface: AnyTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
   private let transportInterfaceInternal: PassthroughTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
   public typealias TransportInterfaceInput = InputFromTransport<NetworkAddress>
   public typealias TransportInterfaceOutput = TransportSendRequest<NetworkAddress>
}
