//
//  AppInfoModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 11/6/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import UIKit

/// App Info Model
public struct AppInfoModel {
    
    /// bundle name example: "AppName"
    let bundleName:String
    
    /// bundleIdentifier example: "com.corp.AppName"
    let bundleIdentifier:String
    
    /// bundle version build version example: 22
    let bundleVersion:String
    
    /// bundle short version "2.3"
    let bundleShortVersion:String
    
    /// make a AppInfoModel based on the current environment
    static func make() -> AppInfoModel {
        
        // get the App Information
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("no Bundle.main.infoDictionary")
        }
        
        let CFBundleShortVersionString = dictionary["CFBundleShortVersionString"] as? String ?? "~"
        let CFBundleVersion = dictionary["CFBundleVersion"] as? String ?? "~"
        let CFBundleName = dictionary["CFBundleName"] as? String ?? "~"
        let CFBundleIdentifier = dictionary["CFBundleIdentifier"] as? String ?? "~"
        // CFBundleShortVersionString version:1.1
        // CFBundleVersion build: 22
        // CFBundleName app:AnalyticsSwiftUIExample
        // CFBundleIdentifier app:com.org.AppName
        
        return AppInfoModel(
            bundleName:CFBundleName,
            bundleIdentifier:CFBundleIdentifier,
            bundleVersion: CFBundleVersion,
            bundleShortVersion: CFBundleShortVersionString
        )
    }
    
    /// mock factory
    public static var mock: AppInfoModel {
        return AppInfoModel(
            bundleName:"CFBundleName",
            bundleIdentifier:"CFBundleIdentifier",
            bundleVersion: "CFBundleVersion",
            bundleShortVersion: "CFBundleShortVersionString"
        )
    }
    
}

