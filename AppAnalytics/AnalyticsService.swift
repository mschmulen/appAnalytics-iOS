//
//  AppDelegate+AnalyticsServicee.swift
//  AnalyticsService
//
//  Created by Matthew Schmulen on 9/27/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import UIKit

/**
 Analytics Service
 
 is the entry point for dispatching analytics to the service.  Analytic events are first stored in local storage and then dispatched to the network based on the rate-limiting configuration of the TokenBucket.  Analytics are not removed from the local storage until it recieves a confirmation from the server that the analytics event has been captured.

 ## Notes on creating custom events
 TOOD
 
 ## Notes on app level event properties
 TOOD
 
 ## Notes on TokenBucket and event dispatch to the network:
 
 Analytics Services utilizes a TokenBucket (simple algorithm used for rate-limiting events and shaping network traffic) refer to the ducumentation in `AnalyticsConfiguration`.
*/
public class AnalyticsService {
    
    public let enableAppleIDFA:Bool
    
    public let enableAppleIDFV:Bool
    
    public let enableCrashReporting:Bool
    
    public let enableAppleSKAdNetwork:Bool
    
    /// internal local device information
    public internal(set) var localDeviceInfo:LocalDeviceInfoModel

    /// internal local device information
    public internal(set) var appInfo:AppInfoModel
    
    public internal(set) var appUserIdentifier:String {
        didSet {
            print( "didSet appUserIdentifier")
            ServerDispatchServices.sendUserInfoToServer(appUserIdentifier: appUserIdentifier)
        }
    }
    
    /// private singleton instance
    private static var sharedAnalyticsService:AnalyticsService!
    
    /// internal token bucket for throttling
    internal let tokenBucket:TokenBucket
    
    /// internal environment : (local, stage, production)
    internal let environment:NetworkEnvironment
    
    /// private initializer
    private init(config: AnalyticsServiceConfiguration) {
        
        //self.cdm = CoreDataManager()
        switch config.environment {
        case .local:
            environment = .local(scheme: config.scheme, host: config.host, port: config.port)
        case .production:
            environment = .production(scheme: config.scheme, host: config.host, port: config.port)
        case .stage:
            environment = .stage(scheme: config.scheme, host: config.host, port: config.port)
        }
        
        // configure for 5 tokens every 1 seconds with a maximum capacity of 20
        tokenBucket = TokenBucket(
            capacity: config.tokenBucketCapacity,
            tokensPerInterval: config.tokenBucketTokensPerInterval,
            interval: config.tokeBucketRefreshIntervalInSeconds,
            initialTokenCount: config.tokenBucketInitialTokenCount
        )
        
        enableAppleIDFA = config.enableAppleIDFA
        enableAppleIDFV = config.enableAppleIDFV
        
        localDeviceInfo = LocalDeviceInfoModel.make(
            enableAppleIDFV: config.enableAppleIDFV,
            enableAppleIDFA: config.enableAppleIDFA
        )
        appInfo = AppInfoModel.make()
        
        enableCrashReporting = config.enableCrashReporting
        enableAppleSKAdNetwork = config.enableAppleSKAdNetwork
        appUserIdentifier = "~"
    }

}

// MARK: public instance methods and properties
extension AnalyticsService {
    
    /// updateAppUserIdentifier
    public func updateAppUserIdentifier( appUserIdentifier:String ) {
        self.appUserIdentifier = appUserIdentifier
    }
    
    /// appIdentifier
    public var appIdentifier:String {
        get {
            return appInfo.bundleIdentifier
        }
    }
    
    /// appVersion
    public var appVersion:String {
        get {
            return appInfo.bundleShortVersion
        }
    }
    
    public var appleIdentifierForVendor:String {
        get {
            return localDeviceInfo.appleIdentifierForVendor
        }
    }
    
}

// MARK: public class methods
extension AnalyticsService {
    
    /// public shared instance accessor
    public class func shared() -> AnalyticsService {
        return sharedAnalyticsService
    }

    /// public configuration of the AnalyticsService library must be called first
    public class func start(config: AnalyticsServiceConfiguration) {
        sharedAnalyticsService = AnalyticsService(config: config)
        
        if config.enableCrashReporting == true {
            CrashService.startCrashReporting()
        }
    }
    
}

// MARK: public Crash helper class methods
extension AnalyticsService {
    
    public class func forceException() {
        CrashService.forceException()
    }
    
    public class func forceCrashForceUnwrap() {
        CrashService.forceCrashForceUnwrap()
    }
    
    public class func forceCrashIndexOutOfRange() {
        CrashService.forceCrashIndexOutOfRange()
    }

}

//// MARK: machine info
//extension AnalyticsService {
//
//    private func machineName() -> String {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let machineMirror = Mirror(reflecting: systemInfo.machine)
//        return machineMirror.children.reduce("") { identifier, element in
//            guard let value = element.value as? Int8, value != 0 else { return identifier }
//            return identifier + String(UnicodeScalar(UInt8(value)))
//        }
//    }
//
//    private func modelIdentifier() -> String {
//        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
//        var sysinfo = utsname()
//        uname(&sysinfo) // ignore return value
//        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
//    }
//}


//import SystemConfiguration
//import UIKit
//
//public extension UIDevice {
//    static let modelName: String = {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let machineMirror = Mirror(reflecting: systemInfo.machine)
//        let identifier = machineMirror.children.reduce("") { identifier, element in
//            guard let value = element.value as? Int8, value != 0 else { return identifier }
//            return identifier + String(UnicodeScalar(UInt8(value)))
//        }
//
//        func mapToDevice(identifier: String) -> String {
//            #if os(iOS)
//            switch identifier {
//            case "iPod5,1":                                 return "iPod Touch 5"
//            case "iPod7,1":                                 return "iPod Touch 6"
//            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
//            case "iPhone4,1":                               return "iPhone 4s"
//            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
//            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
//            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
//            case "iPhone7,2":                               return "iPhone 6"
//            case "iPhone7,1":                               return "iPhone 6 Plus"
//            case "iPhone8,1":                               return "iPhone 6s"
//            case "iPhone8,2":                               return "iPhone 6s Plus"
//            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
//            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
//            case "iPhone8,4":                               return "iPhone SE"
//            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
//            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
//            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
//            case "iPhone11,2":                              return "iPhone XS"
//            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
//            case "iPhone11,8":                              return "iPhone XR"
//            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
//            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
//            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
//            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
//            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
//            case "iPad6,11", "iPad6,12":                    return "iPad 5"
//            case "iPad7,5", "iPad7,6":                      return "iPad 6"
//            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
//            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
//            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
//            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
//            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
//            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
//            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
//            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
//            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
//            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
//            case "AppleTV5,3":                              return "Apple TV"
//            case "AppleTV6,2":                              return "Apple TV 4K"
//            case "AudioAccessory1,1":                       return "HomePod"
//            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
//            default:                                        return identifier
//            }
//            #elseif os(tvOS)
//            switch identifier {
//            case "AppleTV5,3": return "Apple TV 4"
//            case "AppleTV6,2": return "Apple TV 4K"
//            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
//            default: return identifier
//            }
//            #endif
//        }
//
//        return mapToDevice(identifier: identifier)
//    }()
//}
// let modelName = UIDevice.modelName

