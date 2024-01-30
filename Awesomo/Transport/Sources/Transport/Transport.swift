import Domain
import MessagingApp
import Combine
import Foundation
import Utils


public final class Transport {

   public init(tcpClient: TCPClient) {
      self.tcpClient = tcpClient
   }

   public typealias Input = CoreMessenger.State
   public lazy var input: some Subscriber<Input, Never> = inputInternal
   private let inputInternal = PublishingSubscriber<Input, Never>()

   public typealias Output = MessagingApp.InputFromTransport
   public lazy var output: some Publisher<Output, Never> = outputInternal.publisher
   private let outputInternal = PublishingSubscriber<Output, Never>()

   private func sendInvitationPublisher(for peer: Peer.Snapshot) -> some Publisher<Output, Never> {
      return tcpClient.upload(
         "IVova Invites".data(using: .utf8)!,
         for: peer
      )
   }

   public func wireUp() {
      inputInternal
         .publisher
         .flatMap(maxPublishers: .max(1)) { [weak self] domainState in
            guard let self else {
               return Transport.justNilOutput
            }

            for peer in domainState {
               if isUpdatedPeerRelation(peer)
                     && peer.relation == .invitationInitiated {

                  return sendInvitationPublisher(for: peer)
                     .asOptional()
                     .eraseToAnyPublisher()
               }
            }

            return Transport.justNilOutput
         }
         .compactMap { $0 }
         .subscribe(outputInternal)
   }

   private var previousState: Input?

   private func isUpdatedPeerRelation(_ peer: Peer.Snapshot) -> Bool {
      guard let oldPeer = previousState?.first(where: { $0.peerID == peer.peerID }) else {
         return true
      }
      return peer.relation != oldPeer.relation
   }

   private let tcpClient: TCPClient

   private static let justNilOutput: AnyPublisher<Transport.Output?, Never> = Just(nil).eraseToAnyPublisher()
}
