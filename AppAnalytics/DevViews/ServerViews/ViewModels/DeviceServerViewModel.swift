//
//  DeviceServerViewModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

public struct DeviceServerViewModel: Identifiable {
    
    public var id: UUID
    
    let appleIdentifierForVendor: String
    
    let appleIdentifierForAdvertiser: String
    
    let deviceSystemVersion: String
    
    let deviceModel: String
    
    let deviceLocalizedModel: String
    
    let deviceName: String
    
    let deviceSystemName: String
    
    let deviceUserInterfaceIdiom: Int
    
    let lastDeviceUpdateTime: String
    
    let deviceCreationTime: String
    
    static var mock:DeviceServerViewModel {
        return DeviceServerViewModel(
            id: UUID(),
            appleIdentifierForVendor: "mock",
            appleIdentifierForAdvertiser: "mock",
            deviceSystemVersion: "mock",
            deviceModel: "mock",
            deviceLocalizedModel: "mock",
            deviceName: "mock",
            deviceSystemName: "mock",
            deviceUserInterfaceIdiom: 0,
            lastDeviceUpdateTime: "mock",
            deviceCreationTime: "mock"
        )
    }
}
