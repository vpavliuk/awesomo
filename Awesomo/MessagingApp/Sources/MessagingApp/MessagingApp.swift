import Utils
import Domain

public struct MessagingApp {
   public init () {}
   public lazy var transportInterface: AnyTwoWayInterface<TransportOutput, SendRequest> = transportInterfaceInternal.eraseToAny()
   private let transportInterfaceInternal = PassthroughTwoWayInterface<TransportOutput, SendRequest>()
}
