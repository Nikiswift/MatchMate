//
//  MatchMakingApp.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 28/02/25.
//

import SwiftUI

@main
struct MatchMakingApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase
    var viewModel = MateViewModel(repository: Repository<Base>(networkManager: ApiServices()))
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(self.viewModel)
                .onAppear {
                    NetworkConnectionHelper.shared.startNetworkReachabilityObserver()
                }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                viewModel.saveContent()
            case .inactive:
                viewModel.saveContent()
            default:
                break
            }
        }
    }
}
