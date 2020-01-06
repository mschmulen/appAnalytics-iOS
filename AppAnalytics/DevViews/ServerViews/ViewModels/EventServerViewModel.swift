//
//  EventServerViewModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

struct EventServerViewModel: Identifiable {
    
    var id: UUID
    
    let name: String
    
    let creationTime: String
    
    let localDeviceEventUUID: UUID
    
    let appleIdentifierForVendor: String
    
    let appIdentifier: String
    
    let appVersion: String
    
    let appBuildNumber: String
    
    let protectedMetaData: [String: String]
    
    let appMetaData: [String: String]
    
    static var mock:EventServerViewModel {
        return EventServerViewModel (
            id: UUID(),
            name: "mock",
            creationTime: "mock",
            localDeviceEventUUID: UUID(),
            appleIdentifierForVendor: "mock",
            appIdentifier: "mock",
            appVersion: "mock",
            appBuildNumber: "mock",
            protectedMetaData: [String: String](),
            appMetaData: [String: String]()
        )
    }
}
