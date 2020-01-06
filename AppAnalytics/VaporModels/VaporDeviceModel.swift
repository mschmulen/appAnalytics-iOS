//
//  VaporDeviceModel.swift
//

import Foundation

public struct VaporDeviceModel: VaporModel, IDFVQueryableProtocol, PageableProtocol {
    
    public static var endpointRouteURL = "devices"
    
    public let id:VaporID?
    
    public let appleIdentifierForVendor: String
    
    public let appleIdentifierForAdvertiser: String
    
    public let deviceSystemVersion:String
    
    public let deviceModel:String
    
    public let deviceLocalizedModel:String
    
    public let deviceName:String
    
    public let deviceSystemName:String
    
    public let deviceUserInterfaceIdiom:Int
    
    public let lastDeviceUpdateTime:String
    
    public let deviceCreationTime:String

    public let appUserIdentifier: String
    
    public init ( id:VaporID?, deviceInfo:LocalDeviceInfoModel, appUserIdentifier:String ) {
        self.id = id
        
        self.appleIdentifierForVendor = deviceInfo.appleIdentifierForVendor
        self.appleIdentifierForAdvertiser = deviceInfo.appleIdentifierForAdvertiser ?? "~"
        self.deviceSystemVersion = deviceInfo.deviceSystemVersion
        self.deviceModel = deviceInfo.deviceModel
        self.deviceLocalizedModel = deviceInfo.deviceLocalizedModel
        self.deviceName = deviceInfo.deviceName
        self.deviceSystemName = deviceInfo.deviceSystemName
        self.deviceUserInterfaceIdiom = deviceInfo.deviceUserInterfaceIdiom
        self.lastDeviceUpdateTime = "\(Date())"
        self.deviceCreationTime = "\(Date())"
        self.appUserIdentifier = appUserIdentifier
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case appleIdentifierForVendor
        case appleIdentifierForAdvertiser
        case deviceSystemVersion
        case deviceModel
        case deviceLocalizedModel
        case deviceName
        case deviceSystemName
        case deviceUserInterfaceIdiom
        case lastDeviceUpdateTime
        case deviceCreationTime
        case appUserIdentifier
    }
    
    /// mock factory
    public static var mock: VaporDeviceModel {
        return VaporDeviceModel(
            id:nil,
            deviceInfo: LocalDeviceInfoModel.mock,
            appUserIdentifier: "~"
        )
    }

}
