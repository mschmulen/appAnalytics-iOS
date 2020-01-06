//
//  AnalyticEventType.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/12/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

public protocol AnalyticEventProtocol {
    var name:String { get }
}

internal enum PrivateAnalyticEvent: AnalyticEventProtocol {
    
    // App lifeCycle
    case didFinishLaunchingWithOptions
    case applicationDidBecomeActive
    case applicationWillResignActive
    case applicationDidEnterBackground
    case applicationWillEnterForeground
    case applicationWillTerminate
    case applicationDidReceiveMemoryWarning
    
    public var name:String {
        switch self {
        case .didFinishLaunchingWithOptions:
            return "didFinishLaunchingWithOptions"
        case .applicationDidBecomeActive:
            return "applicationDidBecomeActive"
        case .applicationWillResignActive:
            return "applicationWillResignActive"
        case .applicationDidEnterBackground:
            return "applicationDidEnterBackground"
        case .applicationWillEnterForeground:
            return "applicationWillEnterForeground"
        case .applicationWillTerminate:
            return "applicationWillTerminate"
        case .applicationDidReceiveMemoryWarning:
            return "applicationDidReceiveMemoryWarning"
        }
    }
}

public enum AnalyticEvent: AnalyticEventProtocol {
    
    /// pre defined test events
    case testEventA
    case testEventB
    case testEventC
    
    /// view lifecycle events
    case viewDidAppear( viewName: String )
    
    /// custom event will be prefixed with `customEvent.` example : `customEvent.UserDidTapButtonA`
    case customEvent( eventName: String )
    
    public var name:String {
        
        switch self {
            
        case .testEventA: return "testEventA"
        case .testEventB: return "testEventB"
        case .testEventC: return "testEventC"

            
        case .viewDidAppear(let viewName):
            return "viewDidAppear.\(viewName)"
        case .customEvent(let eventName):
            return "customEvent.\(eventName)"
        }
    }
}
