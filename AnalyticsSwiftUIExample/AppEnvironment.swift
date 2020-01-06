//
//  AppEnvironment.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/20/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

var appNetworkEnvironment = AppNetworkEnv.local
//var appNetworkEnvironment = AppNetworkEnv.stage

#if DEBUG
var appBuildEnvironment = AppBuildEnv.debug
#else
var appBuildEnvironment = AppBuildEnv.release
#endif

enum AppNetworkEnv {
    case local
    case stage
    case prod
    
    var description:String {
        switch self {
        case .local: return "local"
        case .stage: return "stage"
        case .prod: return "prod"
        }
    }
    
    var scheme:String {
        switch self {
        case .local: return "http"
        case .stage: return "https"
        case .prod: return "https"
        }
    }
    
    var host:String {
        switch self {
        case .local:
            return "localhost"
        case .stage:
            return "llit-oasis-57526.herokuapp.com"
        case .prod:
            return "llit-oasis-57526.herokuapp.com"
        }
    }

    var port:Int? {
        switch self {
        case .local: return 8080
        case .stage: return nil
        case .prod: return nil
        }
    }
}

enum AppBuildEnv {
    case release
    case debug
    
    var description:String {
        switch self {
        case .release: return "release"
        case .debug: return "debug"
            
        }
    }
}


