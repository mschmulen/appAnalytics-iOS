//
//  CrashServerViewModel.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

struct CrashServerViewModel: Identifiable {
    
    var id: UUID
    
    let crashType: String
    
    let name: String
    
    let reason: String
    
    let appInfo: String
    
    let callStack: String
    
    let creationTime:String
    
    let localDeviceEventUUID:UUID
    
    let appleIdentifierForVendor:String
    
    let appIdentifier: String
    
    let appVersion: String
    
    let appBuildNumber: String
    
    
    struct CallStackRecord: Identifiable {
        var id = UUID()
        var info: String
    }
    
    var callStackPretty:[CallStackRecord] {
        var records = [CallStackRecord]()
        let split = callStack.split(separator: "\r")
        for a in split {
            records.append(
                CallStackRecord(
                    info: "\(a)"
                )
            )
        }
        return records
    }
    
    static var mock: CrashServerViewModel {
        return CrashServerViewModel (
            id: UUID(),
            crashType: "mock",
            name: "mock",
            reason: "mock",
            appInfo: "mock",
            callStack: "mock",
            creationTime:"mock",
            localDeviceEventUUID:UUID(),
            appleIdentifierForVendor:"mock",
            appIdentifier:"mock",
            appVersion:"mock",
            appBuildNumber:"22"
        )
    }
}


