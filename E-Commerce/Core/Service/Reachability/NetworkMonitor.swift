//
//  NetworkMonitor.swift
//  E-Commerce
//
//  Created by AI Assistant on 11.08.2025.
//

import Foundation
import Network

protocol NetworkMonitorProtocol: AnyObject {
    var isConnected: Bool { get }
    var onStatusChange: ((Bool) -> Void)? { get set }
    func start()
    func stop()
}

final class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    var onStatusChange: ((Bool) -> Void)?

    init(queue: DispatchQueue = DispatchQueue(label: "NetworkMonitorQueue")) {
        self.monitor = NWPathMonitor()
        self.queue = queue
    }

    private(set) var isConnected: Bool = true {
        didSet { onStatusChange?(isConnected) }
    }

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}


