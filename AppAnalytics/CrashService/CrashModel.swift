//
//  CrashModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

// References
// - https://github.com/zixun/CrashEye

/**
 Crash Model
 */
class CrashModel: NSObject {
    
    /// CrashType enum signal,exception
    public enum CrashType:Int {
        
        case signal = 1
        case exception = 2
        
        var description:String {
            switch self {
            case .signal: return "signal"
            case .exception: return "exception"
            }
        }
    }
    
    /// crash type
    var type: CrashType!

    /// name
    var name: String!

    /// reason
    var reason: String!

    /// call stack
    var callStack: String!

    /// callStackReturnAddresses
    var callStackReturnAddresses:String!
    
    /// initializer
    init(type:CrashType,
         name:String,
         reason:String,
         callStack:String,
         callStackReturnAddresses:String
    ) {
        super.init()
        self.type = type
        self.name = name
        self.reason = reason
        self.callStack = callStack
        self.callStackReturnAddresses = callStackReturnAddresses
    }
}

