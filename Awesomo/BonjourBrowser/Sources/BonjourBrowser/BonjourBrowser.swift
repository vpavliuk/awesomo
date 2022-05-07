import Foundation
import Combine

public final class BonjourBrowser: NSObject, NetServiceBrowserDelegate {

   public init(serviceType: String) {
      self.seriveType = serviceType
      output = outputInternal.eraseToAnyPublisher()
      super.init()
   }

   deinit {
      stopDiscovery()
      browser.delegate = nil
   }

   public func startDiscovery() {
      browser.searchForServices(ofType: seriveType, inDomain: "")
   }

   public func stopDiscovery() {
      browser.stop()
   }

   public let output: AnyPublisher<NetServiceAvailabilityEvent, Never>

   private let seriveType: String
   private let outputInternal =
         PassthroughSubject<NetServiceAvailabilityEvent, Never>()

// MARK: - NetServiceBrowser
   private lazy var browser: NetServiceBrowser = {
      let theBrowser = NetServiceBrowser()
      //theBrowser.includesPeerToPeer = true
      theBrowser.delegate = self
      return theBrowser
   }()

   public func netServiceBrowser(
         _ browser: NetServiceBrowser,
         didFind service: NetService,
         moreComing: Bool
   ) {
      foundServices.append(service)
      if !moreComing {
         flushFoundServices()
      }
   }

   public func netServiceBrowser(
         _ browser: NetServiceBrowser,
         didRemove service: NetService,
         moreComing: Bool
   ) {
      lostServices.append(service)
      if !moreComing {
         flushLostServices()
      }
   }

// MARK: -
   private var foundServices = [NetService]()
   private var lostServices = [NetService]()

   private func flushFoundServices() {
      outputInternal.send(
         NetServiceAvailabilityEvent(
            availabilityChange: .found,
            services: foundServices
         )
      )

      foundServices.removeAll()
   }

   private func flushLostServices() {
      outputInternal.send(
         NetServiceAvailabilityEvent(
            availabilityChange: .lost,
            services: lostServices
         )
      )

      lostServices.removeAll()
   }
}
