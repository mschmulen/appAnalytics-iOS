//
//  VaporAppModel.swift
//

import Foundation

public struct VaporAppInfoModel: VaporModel, PageableProtocol {
    
    public static var endpointRouteURL = "apps"
    
    /// vapor model ID
    public let id:VaporID?
    
    /// app Identifier example "com.mycompany.myapp"
    public let appIdentifier: String
    
    /// app Version example: "4.5"
    public let appVersion: String
    
    /// app Build build example "44"
    public let appBuild:String
    
    /// target device system name example: "iOS"
    public let deviceSystemName:String
    
    // hash of the defining charactersitings of the
    public let appHash:Int
    
    public let lastUpdateTime:String
    
    public init ( appInfo: AppInfoModel, id:VaporID? ) {
        self.appIdentifier = appInfo.bundleIdentifier
        self.appVersion = appInfo.bundleShortVersion
        self.appBuild = appInfo.bundleVersion
        self.deviceSystemName = "iOS"
        self.id = id
//        let hashString = deviceSystemName + appIdentifier + appVersion + appBuild
//        self.appHash = hashString.hashValue
        self.appHash = 0
        self.lastUpdateTime = "\(Date())"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case appIdentifier
        case appVersion
        case appBuild
        case deviceSystemName
        case appHash
        case lastUpdateTime
    }
    
    /// mock factory
    public static var mock: VaporAppInfoModel {
        return VaporAppInfoModel(appInfo: AppInfoModel.mock, id: nil)
    }
    
}
