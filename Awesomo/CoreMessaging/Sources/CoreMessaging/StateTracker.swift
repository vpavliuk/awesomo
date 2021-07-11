//
//  StateTracker.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 02.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

/// A facade object that hides PeerTracker, UploadTracker, and DownloadTracker behind itself.
public struct StateTracker<
   ConcretePeer: Peer,
   ConcreteMessage: Message
> where ConcretePeer.ID == String {

   public init(state: AppState<ConcretePeer, ConcreteMessage>) {

      self.peerTracker = PeerTracker(
         localPeerId: state.localPeerId,
         state: state.peersState
      )

      self.uploadTracker = UploadTracker(state: state.outgoingState)

      self.downloadTracker = DownloadTracker(state: state.incomingState)
   }

   public func trackEvents<
      ServiceEvent: AvailabilityEvent,
      ServicePublisher: Publisher,
      UploadPublisher: Publisher,
      DownloadPublisher: Publisher
   >(
      servicePublisher: ServicePublisher,
      uploadPublisher: UploadPublisher,
      downloadPublisher: DownloadPublisher
   ) where
         ServiceEvent.Object == ConcretePeer.Service,
         ServicePublisher.Output == Set<ServiceEvent>,
         ServicePublisher.Failure == Never,
         UploadPublisher.Output == Upload<ConcretePeer, ConcreteMessage>.ID,
         UploadPublisher.Failure == Never,
         DownloadPublisher.Output == NetworkMessage<ConcretePeer, ConcreteMessage.Payload>,
         DownloadPublisher.Failure == Never {

      peerTracker.trackPeers(publisher: servicePublisher)
      uploadTracker.trackUploads(publisher: uploadPublisher)
      downloadTracker.trackDownloads(publisher: downloadPublisher)
   }

   private var peerTracker: PeerTracker<ConcretePeer>
   private var uploadTracker: UploadTracker<ConcretePeer, ConcreteMessage>
   private var downloadTracker: DownloadTracker<ConcretePeer, ConcreteMessage>
}
