//
//  AppServerViewModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

public struct AppServerViewModel: Identifiable {
    
    public var id: UUID
    
    let appIdentifier: String
    
    let appVersion: String
    
    let appBuild: String
    
    let deviceSystemName: String
    
    let appHash: Int
    
    let lastUpdateTime: String
    
    static var mock:AppServerViewModel {
        return AppServerViewModel(
            id: UUID(),
            appIdentifier: "mock",
            appVersion: "mock",
            appBuild: "mock",
            deviceSystemName: "mock",
            appHash: 1,
            lastUpdateTime: "mock"
        )
    }
}

