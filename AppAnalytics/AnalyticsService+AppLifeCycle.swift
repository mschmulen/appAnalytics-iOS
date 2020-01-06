//
//  AnalyticsService+AppLifeCycle.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/11/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

// MARK: App Lifecycle
extension AnalyticsService {
    
    /// didFinishLaunchingWithOptions must be called after `AnalyticsService.configure` preferably as the last call in the AppDelegate didFinishLaunchingWithOptions
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // print ("didFinishLaunchingWithOptions")
        // print ("application\(application)")
        // print ("launchOptions \(String(describing: launchOptions))")
        
        // get device info
        AnalyticsService.shared().localDeviceInfo = LocalDeviceInfoModel.make(
            enableAppleIDFV: enableAppleIDFV,
            enableAppleIDFA: enableAppleIDFA
        )
        
        ServerDispatchServices.sendAppInfoToServer()
        ServerDispatchServices.sendDeviceInfoToServer()
        ServerDispatchServices.sendLocalCrashEventsToServer()

        AnalyticsService.dispatchAnalyticEvent(.didFinishLaunchingWithOptions)
        
        AnalyticsService.shared().triggerLocalDataFlush()
        
        if enableAppleSKAdNetwork {
            if #available(iOS 11.3, *) {
                SKAdNetwork.registerAppForAdNetworkAttribution()
            } else {
                // Fallback on earlier versions
                print( "SKAdNetwork is not available on this target")
            }
        }
        return true
    }
    
    /// applicationDidBecomeActive
    public func applicationDidBecomeActive(_ application: UIApplication) {
        AnalyticsService.dispatchAnalyticEvent(.applicationDidBecomeActive)
    }

    /// applicationWillResignActive
    public func applicationWillResignActive(_ application: UIApplication) {
        AnalyticsService.dispatchAnalyticEvent(.applicationWillResignActive)
    }
    
    /// applicationDidEnterBackground
    public func applicationDidEnterBackground(_ application: UIApplication) {
        AnalyticsService.dispatchAnalyticEvent(.applicationDidEnterBackground)
    }
    
    /// applicationWillEnterForeground
    public func applicationWillEnterForeground(_ application: UIApplication) {
        AnalyticsService.dispatchAnalyticEvent(.applicationWillEnterForeground)
    }
    
    /// applicationWillTerminate
    public func applicationWillTerminate(_ application: UIApplication) {
        AnalyticsService.dispatchAnalyticEvent(.applicationWillTerminate)
    }
    
    /// applicationDidReceiveMemoryWarning
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        AnalyticsService.dispatchAnalyticEvent(.applicationDidReceiveMemoryWarning)
    }
    
}

// MARK: UISceneSession Lifecycle
extension AnalyticsService {
    
    @available(iOS 13.0, *)
    public class func configurationForConnecting(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions){
        print( "configurationForConnecting")
    }
    
    @available(iOS 13.0, *)
    public class func didDiscardSceneSessions(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("didDiscardSceneSessions")
    }
    
}

// sim run
//        didFinishLaunchingWithOptions
//        application<UIApplication: 0x7f935bf02880>
//        launchOptions nil
//        CFBundleShortVersionString version:Optional("1.0")
//        CFBundleVersion build: Optional("1")
//        CFBundleName app:Optional("weatherApp")
//        device.systemVersion:  12.4
//        device.model : iPhone
//        device.localizedModel : iPhone
//        device.name : iPhone 6
//        applicationDidBecomeActive
        
        //device run
//        didFinishLaunchingWithOptions
//        application<UIApplication: 0x103201b40>
//        launchOptions nil
//        CFBundleShortVersionString version:Optional("1.0")
//        CFBundleVersion build: Optional("1")
//        CFBundleName app:Optional("weatherApp")
//        device.systemVersion:  12.2
//        device.model : iPhone
//        device.localizedModel : iPhone
//        device.name : MAS X
//        applicationDidBecomeActive
