//
//  NetworkMonitor.swift
//  Test
//
//  Created by BS236 on 27/12/21.
//

import Foundation
import Network

final class NetworkMonitor {
    //creating singleton object
    static let shared = NetworkMonitor()
    
    //creating queue and path monitor
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    //creating enum for different types of network
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    //creating var for checking connecting and making the setters private so that only this class can set them
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    //constructor
    private init() {
        monitor = NWPathMonitor()
    }
    
    //starting the monitoring process and updating the variables accordingly
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {
            [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    //used to stop connection
    public func stopMonitoring() {
        monitor.cancel() 
    }
    
    //using the data from startMonitoring and set variable according to enum
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
}
