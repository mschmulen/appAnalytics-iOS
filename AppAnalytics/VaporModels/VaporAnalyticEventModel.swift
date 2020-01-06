//
//  VaporAnalyticEventModel.swift
//

import Foundation

/// Vapor Event model for outgoing serialization to the endpoint
public struct VaporAnalyticEventModel: VaporModel, IDFVQueryableProtocol, AppQueryableProtocol, PageableProtocol {
    
    public static var endpointRouteURL = "events"
    
    public let id:VaporID?
    
    /// name of the event
    public let name: String
    
    /// the date time string of when the event was initially created on the device
    public let creationTime:String
    
    /// localDeviceEvent UUID to make sure events are only registered a single time in case of network failure or multiple submissions of the same event
    public let localDeviceEventUUID:UUID
    
    /// this device IDFV as defined by apple
    public let appleIdentifierForVendor:String
    
    /// app Identifier example: com.org.appName
    public let appIdentifier: String

    /// appVersion example: 3.12
    public let appVersion: String

    /// appBuildNumber incrimenting build number for a given appVersion example: 333
    public let appBuildNumber: String
    
    /// protected meta data provided by the framework
    public let protectedMetaData: [String: String]
    
    // public metadata that is provided by the applications space
    public let appMetaData: [String: String]
    
    public let appUserIdentifier: String
    
    /// initializer
    public init (
        name: String,
        creationTime: String,
        localDeviceEventUUID: UUID,
        appleIdentifierForVendor: String,
        appIdentifier: String,
        appVersion: String,
        appBuildNumber: String,
        protectedMetaData: [String:String],
        appMetaData: [String: String],
        appUserIdentifier: String,
        id: VaporID?
    )
    {
        self.name = name
        self.creationTime = creationTime
        self.localDeviceEventUUID = localDeviceEventUUID
        self.appleIdentifierForVendor = appleIdentifierForVendor
        self.appIdentifier = appIdentifier
        self.appVersion = appVersion
        self.appBuildNumber = appBuildNumber
        self.protectedMetaData = protectedMetaData
        self.appMetaData = appMetaData
        self.appUserIdentifier = appUserIdentifier
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case creationTime
        case localDeviceEventUUID
        case appleIdentifierForVendor
        case appIdentifier
        case appVersion
        case appBuildNumber
        case protectedMetaData
        case appMetaData
        case appUserIdentifier
    }
    
    /// mock factory
    public static var mock: VaporAnalyticEventModel {
        return VaporAnalyticEventModel(
            name: "mockEvent",
            creationTime: "\(Date())",
            localDeviceEventUUID: UUID(),
            appleIdentifierForVendor: "mock",
            appIdentifier: "mock",
            appVersion: "mock",
            appBuildNumber: "mock",
            protectedMetaData: [:],
            appMetaData: [:],
            appUserIdentifier: "~",
            id: nil)
    }
    
}
