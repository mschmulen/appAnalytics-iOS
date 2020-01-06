//
//  Analytics+Server.swift
//  AppAnalytics
//

import Foundation

/// ServerDispatchServices
internal class ServerDispatchServices {
    
    /// sendDeviceInfoToServer
    public class func sendDeviceInfoToServer() {
        let localDeviceInfo = AnalyticsService.shared().localDeviceInfo
        let vaporModel = VaporDeviceModel(
            id: nil,
            deviceInfo: localDeviceInfo,
            appUserIdentifier: "~"
        )
        let service = VaporNetworkService<VaporDeviceModel>()
        service.createGeneric(model: vaporModel) { (model, error) in
            if let error = error {
                print("error \(error)" )
            }
        }
    }
    
    /// sendAppInfoToServer
    public class func sendAppInfoToServer() {
        let localAppInfo = AppInfoModel.make()
        let vaporModel = VaporAppInfoModel(appInfo: localAppInfo, id: nil )
        let service = VaporNetworkService<VaporAppInfoModel>()
        service.createGeneric(model: vaporModel) { (model, error) in
            if let error = error {
                print("error \(error)" )
            }
        }
    }
    
    /// sendUserInfoToServer
    public class func sendUserInfoToServer( appUserIdentifier: String ) {
        
        let vaporModel = VaporUserModel(
            associatedAppUserIdentifier: appUserIdentifier,
            id: nil
        )
        let service = VaporNetworkService<VaporUserModel>()
        service.createGeneric(model: vaporModel) { (model, error) in
            if let error = error {
                print("error dispatching VaporUserModel \(error)" )
            }
        }
    }


    /// sendLocalCrashEventsToServer
    public class func sendLocalCrashEventsToServer() {
        let localCrashEvents = CoreDataManager.shared.fetchLocalCrashEventsOldestFirst()
        for (_,event) in localCrashEvents.enumerated() {
            ServerDispatchServices.sendCrashEventToServerAndDeleteFromCoreData(event)
        }
    }
}

// Mark: CrashEventServices
extension ServerDispatchServices {
    
    public class func sendCrashEventToServerAndDeleteFromCoreData(_ crashEvent:CoreDataCrashEvent) {
        let name = crashEvent.name ?? "~"
        let crashType = crashEvent.crashType ?? "~"
        let reason = crashEvent.reason ?? "~"
        let appInfo = "~"
        let callStack = crashEvent.callStack ?? "~"
        let creationTime = crashEvent.dispatchTime ?? Date()
        let localEventUUID = crashEvent.localCrashUUID ?? UUID()
        let appleIdentifierForVendor = AnalyticsService.shared().localDeviceInfo.appleIdentifierForVendor
        let appUserIdentifier = crashEvent.appUserIdentifier ?? "~"
        
        let vaporModel = VaporCrashEventModel(
            crashType: crashType,
            name: name,
            reason: reason,
            appInfo: appInfo,
            callStack: callStack,
            creationTime: "\(creationTime)",
            localDeviceEventUUID: localEventUUID,
            appleIdentifierForVendor:appleIdentifierForVendor,
            appIdentifier: AnalyticsService.shared().appInfo.bundleIdentifier,
            appVersion: AnalyticsService.shared().appInfo.bundleShortVersion,
            appBuildNumber: AnalyticsService.shared().appInfo.bundleVersion,
            appUserIdentifier: appUserIdentifier,
            id: nil
        )
        
        let service = VaporNetworkService<VaporCrashEventModel>()
        service.createGeneric(model: vaporModel) { (model, error) in
            print( "response \(String(describing: model)) \nerror:\(String(describing: error))")
            if let error = error {
                print("error \(error)" )
            } else {
                // on confirmation remove from the local data store
                _ = CoreDataManager.shared.deleteCrashEvent(crashEvent)
            }
        }
    }
    
    public class func sendEventToServerAndDeleteFromCoreData(_ localEvent:CoreDataLocalEvent) {
        
        // Thread.printCurrent("sendEventToServerAndDeleteFromCoreData")
        
        let name = localEvent.name ?? "~"
        let creationTime = localEvent.dispatchTime ?? Date()
        let localDeviceEventUUID = localEvent.localDeviceEventUUID ?? UUID()
        let appleIdentifierForVendor = AnalyticsService.shared().localDeviceInfo.appleIdentifierForVendor
        
        let protectedMeta = [
            "Pyack":"Pfoo",
            "Pyack2":"Pfoo2"
        ]
        
        let appMeta = [
            "Ayack":"Afoo",
            "Ayack2":"Afoo2",
            "Ayack3":"Afoo3"
        ]
        
        let vaporModel = VaporAnalyticEventModel(
            name: name,
            creationTime: "\(creationTime)",
            localDeviceEventUUID: localDeviceEventUUID,
            appleIdentifierForVendor: appleIdentifierForVendor,
            appIdentifier: localEvent.appIdentifier ?? "~",
            appVersion: localEvent.appVersion ?? "~",
            appBuildNumber: localEvent.appBuildNumber ?? "~",
            protectedMetaData:protectedMeta,
            appMetaData: appMeta,
            appUserIdentifier: "~",
            id: nil
        )
        
        let service = VaporNetworkService<VaporAnalyticEventModel>()
        service.createGeneric(model: vaporModel) { (model, error) in
            //print( "response \(String(describing: model)) \nerror:\(String(describing: error))")
            if let error = error {
                print("error \(error)" )
            } else {
                // on confirmation remove from the local data store
                _ = CoreDataManager.shared.deleteEvent(localEvent)
            }
        }
    }
    

}











// Mark: User Services
//extension AnalyticsService {
//
//    public class func sendUserToServer(_ deviceGUID:String) {
//        print( "sendDeviceToServer deviceGUID = \(deviceGUID)")
//
//        let dispatchEvent = VaporDeviceModel(deviceGUID: deviceGUID, id: nil)
//        let uuidResult = AnalyticsService.dispatchToNetwork(dispatchEvent )
//        print( "uuidResult \(String(describing: uuidResult))")
//    }
//
//}
