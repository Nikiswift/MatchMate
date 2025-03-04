//
//  NetworkConnectionHelper.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import Foundation
import Alamofire
import Combine

extension Notification.Name {
    static let networkDidChange = Notification.Name(rawValue: "kReachabilityDidChangeNotification")
}

enum ReachabilityStatus: String {
    case online = "Network_Online"
    case offline = "Network_Offline"
}

// MARK: NetworkConnectionHelper

final class NetworkConnectionHelper: NSObject {
    static var shared = NetworkConnectionHelper()
    private var reachabilityManager = NetworkReachabilityManager()
    private var cancellables = Set<AnyCancellable>()
    
    let networkStatusPublisher = PassthroughSubject<ReachabilityStatus, Never>()
    private override init() {}
    
    //MARK: Netowork Rechability Observer
    func startNetworkReachabilityObserver() {
//        reachabilityManager?.startListening { [weak self] status in
////            switch status {
////            case .notReachable:
////                print("No internet connection.")
////                self?.networkStatusPublisher.send(.offline)
////            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
////                print("Internet connection reachable.")
////                self?.networkStatusPublisher.send(.online)
////            case .unknown:
////                print("Internet connection status unknown.")
////            }
//        }
    }
    
    func stopNetworkReachabilityObserver() {
        reachabilityManager?.stopListening()
    }
}
