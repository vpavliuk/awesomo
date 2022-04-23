import Utils
import Domain
import Combine

public struct MessagingApp<NetworkAddress, ContentNetworkRepresentation> {
   public init() {
      transportInterfaceInternal = PassthroughTwoWayInterface()
      transportInterface = transportInterfaceInternal.eraseToAny()
   }

   public let transportInterface: AnyTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
   private let transportInterfaceInternal: PassthroughTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
   public typealias TransportInterfaceInput = InputFromTransport<NetworkAddress, ContentNetworkRepresentation>
   public typealias TransportInterfaceOutput = TransportSendRequest<NetworkAddress, ContentNetworkRepresentation>
}
