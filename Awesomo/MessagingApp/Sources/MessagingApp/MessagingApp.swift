import Utils
import Domain

public struct MessagingApp {
   let transportInterfaceInternal = PassthroughTwoWayInterface<Int, SendRequest>()
}
