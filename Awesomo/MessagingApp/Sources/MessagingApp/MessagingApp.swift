import Utils
import Domain
import Combine

public struct MessagingApp {
   public init() {
      transportInterfaceInternal = PassthroughTwoWayInterface()
      transportInterface = transportInterfaceInternal.eraseToAny()
   }

   public let transportInterface: AnyTwoWayInterface<TransportOutput, SendRequest>
   private let transportInterfaceInternal: PassthroughTwoWayInterface<TransportOutput, SendRequest>
}
