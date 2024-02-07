import Domain
import MessagingApp
import Combine
import Foundation
import Utils


public final class TransportProcessor {

   public init(tcpClient: TCPClient) {
      self.tcpClient = tcpClient
   }

   public typealias InputFromApp = CoreMessenger.State
   public lazy var inputFromApp: some Subscriber<InputFromApp, Never> = inputFromAppInternal
   private let inputFromAppInternal = PublishingSubscriber<InputFromApp, Never>()

   public typealias InputFromNetwork = Data
   public lazy var inputFromNetwork: some Subscriber<InputFromNetwork, Never> = inputFromNetworkInternal
   private let inputFromNetworkInternal = PublishingSubscriber<InputFromNetwork, Never>()

   public typealias Output = MessagingApp.InputFromTransport
   public lazy var output: some Publisher<Output, Never> = outputInternal.publisher
   private let outputInternal = PublishingSubscriber<Output, Never>()

   public func wireUp() {
      inputFromAppInternal
         .publisher
         .flatMap(maxPublishers: .max(1), outputPublisherFromState)
         .merge(with: incomingTrafficOutput)
         .subscribe(outputInternal)
   }

   private func outputPublisherFromState(_ peers: [Peer.Snapshot]) -> some Publisher<Output, Never> {
      return peers
         .publisher
         .flatMap(maxPublishers: .max(1), outputPublisherFromPeer)
   }

   private func outputPublisherFromPeer(peer: Peer.Snapshot) -> some Publisher<Output, Never> {
      return sendInvitationPublisher(for: peer)
         .concatenate(
            sendMessagesPublisher(for: peer)
         )
   }

   private func sendInvitationPublisher(for peer: Peer.Snapshot) -> some Publisher<Output, Never> {
      guard isUpdatedPeerRelation(peer)
               && peer.relation == .invitationInitiated else {
         return Empty().eraseToAnyPublisher()
      }

      return tcpClient
         .upload(
            "IVova Invites".data(using: .utf8)!,
            to: peer.networkAddress,
            successResultValue: .invitationForPeerWasSentOverNetwork(peer.peerID),
            failureResultValue: .failedToSendInvitationOverNetwork(peer.peerID)
         )
         .eraseToAnyPublisher()
   }

   private func sendMessagesPublisher(for peer: Peer.Snapshot) -> some Publisher<Output, Never> {
      let messagesToSend = peer
         .outgoingMessages
         .filter { isUpdatedOutgoingMessageStatus($0) && $0.status == .pending }

      return messagesToSend
         .publisher
         .map { ($0, peer) }
         .flatMap(maxPublishers: .max(1), sendSingleMessagePublisher)
   }

   private func isUpdatedOutgoingMessageStatus(_ message: OutgoingChatMessage.Snapshot) -> Bool {
      let allPreviousOutgoingMessages = previousState?.reduce([]) { $0 + $1.outgoingMessages }
      guard let oldMessage = allPreviousOutgoingMessages?.first(where: { $0.messageID == message.messageID }) else {
         return true
      }
      return message.status != oldMessage.status
   }

   private func sendSingleMessagePublisher(
      _ message: OutgoingChatMessage.Snapshot,
      for peer: Peer.Snapshot
   ) -> some Publisher<Output, Never> {

      return tcpClient.upload(
         "IVova sends his regards".data(using: .utf8)!,
         to: peer.networkAddress,
         successResultValue: .messageWasSentOverNetwork(message.messageID),
         failureResultValue: .failedToSendMessageOverNetwork(message.messageID)
      )
   }

   private static func outputFromTCPData(tcpData: Data) -> Output? {
      #warning("To implement")
      return .peerInvitedUs(Peer.ID(value: ""))
   }

   private var incomingTrafficOutput: some Publisher<Output, Never> {
      return inputFromNetworkInternal
         .publisher
         .compactMap(Self.outputFromTCPData)
   }

   private var previousState: InputFromApp?

   private func isUpdatedPeerRelation(_ peer: Peer.Snapshot) -> Bool {
      guard let oldPeer = previousState?.first(where: { $0.peerID == peer.peerID }) else {
         return true
      }
      return peer.relation != oldPeer.relation
   }

   private let tcpClient: TCPClient
}
