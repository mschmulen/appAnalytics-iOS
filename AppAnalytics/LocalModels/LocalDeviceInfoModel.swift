//
//  LocalDeviceInfoModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 11/6/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import UIKit
import AdSupport // for IDFA

/// Local Device Info Model
public struct LocalDeviceInfoModel {
    
    /// identifier for vendor
    let appleIdentifierForVendor: String
    
    /// identifier for Advertiser
    let appleIdentifierForAdvertiser: String?
    
    /// device system version
    let deviceSystemVersion:String
    
    /// device Model
    let deviceModel:String
    
    /// device Localized Model
    let deviceLocalizedModel:String
    
    /// device Name
    let deviceName:String
    
    /// device System Name
    let deviceSystemName:String
    
    /// device User Interface Idiom
    let deviceUserInterfaceIdiom:Int
    
    /// make a LocalDeviceInfoModel based on the current environment
    static func make( enableAppleIDFV: Bool, enableAppleIDFA: Bool ) -> LocalDeviceInfoModel {
        
        let device = UIDevice.current
        let deviceSystemVersion = device.systemVersion
        let deviceModel = device.model
        let deviceLocalizedModel = device.localizedModel
        
        let deviceName = device.name
        let deviceSystemName = device.systemName
        let deviceUserInterfaceIdiom = device.userInterfaceIdiom.rawValue
        
        var appleIdentifierForVendor = "~"
        var deviceIdentifierForAdvertiser:String? = nil
        
        if enableAppleIDFV {
            if let IDFV = device.identifierForVendor?.uuidString {
                appleIdentifierForVendor = IDFV
            }
        }
        
        if enableAppleIDFA {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                let IDFAString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                deviceIdentifierForAdvertiser = IDFAString
            } else {
                print("ADVERTISING TRACKING NOT ENABLED ON DEVICE")
                deviceIdentifierForAdvertiser = nil
            }
        } else {
            // print("ADVERTISING TRACKING NOT ENABLED IN ANALYTICS SERVICE")
            deviceIdentifierForAdvertiser = nil
        }
        
        return LocalDeviceInfoModel(
            appleIdentifierForVendor: appleIdentifierForVendor,
            appleIdentifierForAdvertiser: deviceIdentifierForAdvertiser,
            deviceSystemVersion: deviceSystemVersion,
            deviceModel: deviceModel,
            deviceLocalizedModel: deviceLocalizedModel,
            deviceName: deviceName,
            deviceSystemName: deviceSystemName,
            deviceUserInterfaceIdiom: deviceUserInterfaceIdiom
        )
    }
    
    /// mock factory
    public static var mock: LocalDeviceInfoModel {
        return LocalDeviceInfoModel(
            appleIdentifierForVendor: "device.identifierForVendor",
            appleIdentifierForAdvertiser: "device.identifierForAdvertiser",
            deviceSystemVersion: "device.systemVersion",
            deviceModel: "device.model",
            deviceLocalizedModel: "device.localizedModel",
            deviceName: "device.name",
            deviceSystemName: "device.systemName",
            deviceUserInterfaceIdiom:0
        )
    }
    
}
