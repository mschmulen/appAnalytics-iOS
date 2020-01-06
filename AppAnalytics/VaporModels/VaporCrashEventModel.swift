//
//  VaporCrashEventModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

/// VaporCrashEventModel
public struct VaporCrashEventModel: VaporModel, IDFVQueryableProtocol, AppQueryableProtocol, PageableProtocol {
    
    public static var endpointRouteURL = "crashs"
    
    public let id:VaporID?
        
    /// crash Type: "signal", "exception"
    public let crashType: String
    
    /// name
    public let name: String

    /// reason
    public let reason: String

    /// appInfo
    public let appInfo: String

    /// callStack
    public let callStack: String
    
    /// the date time string of when the event was initially created on the device
    public let creationTime:String
    
    /// localDeviceUUID UUID to make sure events are only registered a single time in case of network failure or multiple submissions of the same event
    public let localDeviceEventUUID:UUID
    
    /// this device IDFV as defined by apple
    public let appleIdentifierForVendor:String
    
    public let appIdentifier: String

    public let appVersion: String
    
    public let appBuildNumber: String

    public let appUserIdentifier: String
    
    /// initializer
    public init (
        crashType:String,
        name: String,
        reason:String,
        appInfo:String,
        callStack:String,
        creationTime:String,
        localDeviceEventUUID:UUID,
        appleIdentifierForVendor:String,
        appIdentifier: String,
        appVersion: String,
        appBuildNumber: String,
        appUserIdentifier:String,
        id:VaporID? )
    {
        self.crashType = crashType
        self.name = name
        self.reason = reason
        self.appInfo = appInfo
        self.callStack = callStack
        self.creationTime = creationTime
        self.localDeviceEventUUID = localDeviceEventUUID
        self.appleIdentifierForVendor = appleIdentifierForVendor
        self.appIdentifier = appIdentifier
        self.appVersion = appVersion
        self.appBuildNumber = appBuildNumber
        self.appUserIdentifier = appUserIdentifier
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case crashType
        case name
        case reason
        case appInfo
        case callStack
        case creationTime
        case localDeviceEventUUID
        case appleIdentifierForVendor
        case appIdentifier
        case appVersion
        case appBuildNumber
        case appUserIdentifier
    }
    
    /// mock factory
    public static var mock: VaporCrashEventModel {
        return VaporCrashEventModel(
            crashType: "yackType",
            name: "yackEvent",
            reason: "reason",
            appInfo: "appInfo",
            callStack: "callStack",
            creationTime: "\(Date())",
            localDeviceEventUUID: UUID(),
            appleIdentifierForVendor: "~",
            appIdentifier: "~",
            appVersion: "~",
            appBuildNumber: "~",
            appUserIdentifier: "~",
            id: nil)
    }
    
}


