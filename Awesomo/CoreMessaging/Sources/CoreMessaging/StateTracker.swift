//
//  StateTracker.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 02.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

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
      ServiceNotifier: FocusedEventStreamer,
      UploadNotifier: FocusedEventStreamer,
      DownloadNotifier: FocusedEventStreamer
   >(
      serviceNotifier: ServiceNotifier,
      uploadNotifier: UploadNotifier,
      downloadNotifier: DownloadNotifier
   ) where
         ServiceEvent.Object == ConcretePeer.Service,
         ServiceNotifier.Output == Set<ServiceEvent>,
         UploadNotifier.Output == Upload<ConcretePeer, ConcreteMessage>.ID,
         DownloadNotifier.Output == NetworkMessage<ConcretePeer, ConcreteMessage.Payload> {

      peerTracker.trackPeers(serviceBrowser: serviceNotifier)
      uploadTracker.trackUploads(notifier: uploadNotifier)
      downloadTracker.trackDownloads(notifier: downloadNotifier)
   }

   private var peerTracker: PeerTracker<ConcretePeer>
   private var uploadTracker: UploadTracker<ConcretePeer, ConcreteMessage>
   private var downloadTracker: DownloadTracker<ConcretePeer, ConcreteMessage>
}
