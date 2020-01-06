//
//  AppServerData.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

class AppServerData: ObservableObject {
    
    @Published var pageLimit: Int
    @Published var currentPage: Int
    
    @Published var apps: [AppServerViewModel]
    
    init() {
        pageLimit = 5
        currentPage = 0
        self.apps = []
    }
    
    func nextPage() {
        currentPage += 1
        load()
    }
    
    func prevPage() {
        if currentPage <= 0 {
            currentPage = 0
        } else {
            currentPage -= 1
        }
        load()
    }

    func load() {
        let service = VaporNetworkService<VaporAppInfoModel>()
        service.pagableFetch(limit: pageLimit, page: currentPage) { (serverApps) in
            guard let serverApps = serverApps else { return }
            self.apps = []
            for app in serverApps {
                self.apps.append(
                    AppServerViewModel(
                        id: UUID(),
                        appIdentifier: app.appIdentifier,
                        appVersion: app.appVersion,
                        appBuild: app.appBuild,
                        deviceSystemName: app.deviceSystemName,
                        appHash: app.appHash,
                        lastUpdateTime: app.lastUpdateTime
                    )
                )
            }
        }
    }
    
}

