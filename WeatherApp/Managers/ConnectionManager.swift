//
//  ConnectionManager.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 12.12.23.
//

import UIKit
import Network

class ConnectionManager {
    
    static let shared = ConnectionManager()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public var isConnected: Bool = false
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
}
