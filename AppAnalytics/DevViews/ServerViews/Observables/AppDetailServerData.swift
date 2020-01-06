//
//  AppDetailServerData.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/19/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

class AppDetailServerData: ObservableObject{
    
    // TODO time span
    @Published var newDevices: Int
    @Published var activeDevices: Int
    @Published var crashCount: Int
    
    @Published var appIdentifier:String
    @Published var appVersion:String
    
    // paging info
    @Published var pageLimit: Int
    @Published var currentPage: Int
    @Published var crashs: [CrashServerViewModel]
    @Published var events: [EventServerViewModel]
    
    init(appIdentifier:String, appVersion:String) {
        self.newDevices = 0
        self.activeDevices = 0
        self.crashCount = 0
        
        self.appIdentifier = appIdentifier
        self.appVersion = appVersion
        
        self.pageLimit = 5
        self.currentPage = 0
        crashs = []
        events = []
    }
    
    func nextPage( ) {
        currentPage += 1
        load( )
    }
    
    func prevPage( ) {
        if currentPage <= 0 {
            currentPage = 0
        } else {
            currentPage -= 1
        }
        load( )
    }
    
    func load() {
        loadCrashs()
        loadEvents()
    }
    
    func loadCrashs() {
        let service = VaporNetworkService<VaporCrashEventModel>()
        service.customFetch(limit: pageLimit, page: currentPage, appIdentifier: appIdentifier, appVersion:appVersion) { (serverCrashs) in
            guard let serverCrashs = serverCrashs else { return }
            
            self.crashs = []
            for crash in serverCrashs {
                self.crashs.append(
                    CrashServerViewModel(
                        id: UUID(),
                        crashType: crash.crashType,
                        name: crash.name,
                        reason: crash.reason,
                        appInfo: crash.appInfo,
                        callStack: crash.callStack,
                        creationTime: crash.creationTime,
                        localDeviceEventUUID: crash.localDeviceEventUUID,
                        appleIdentifierForVendor: crash.appleIdentifierForVendor,
                        appIdentifier: crash.appIdentifier,
                        appVersion: crash.appVersion,
                        appBuildNumber: crash.appBuildNumber)
                )
            }
        }
    }//end load crashs
    
    func loadEvents( ) {
        
        let service = VaporNetworkService<VaporAnalyticEventModel>()
        
        service.customFetch(limit: pageLimit, page: currentPage, appIdentifier: appIdentifier, appVersion: appVersion) { (serverEvents) in
            //        service.customFetch(limit: pageLimit, page: currentPage, appleIdentifierForVendor:nil, appIdentifier:appIdentifier, appVersion:appVersion) { (serverEvents) in
            
            guard let serverEvents = serverEvents else {
                return
            }
            
            self.events = []
            for event in serverEvents {
                //print( "event \(event.deviceIDFV)")
                self.events.append(
                    EventServerViewModel(
                        id: UUID(),
                        name: event.name,
                        creationTime: event.creationTime,
                        localDeviceEventUUID: event.localDeviceEventUUID,
                        appleIdentifierForVendor: event.appleIdentifierForVendor,
                        appIdentifier: event.appIdentifier,
                        appVersion: event.appVersion,
                        appBuildNumber: event.appBuildNumber,
                        protectedMetaData: [String: String](),
                        appMetaData: [String: String]()
                    )
                )
            }
        }
    }//end loadEvents
    
}

