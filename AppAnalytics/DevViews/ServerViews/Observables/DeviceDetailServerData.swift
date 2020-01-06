//
//  DeviceDetailServerData.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/19/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

public class DeviceDetailServerData: ObservableObject {
    
    // TODO time span ?
    @Published var eventCount: Int
    @Published var crashCount: Int
    
    @Published var appleIdentifierForVendor:String
    
    // paging info
    @Published var pageLimit: Int
    @Published var currentPage: Int
    @Published var events: [EventServerViewModel]
    @Published var crashs: [CrashServerViewModel]
    
    init( appleIdentifierForVendor:String ) {
        self.eventCount = 0
        self.crashCount = 0
        
        self.appleIdentifierForVendor = appleIdentifierForVendor
        
        self.pageLimit = 5
        self.currentPage = 0
        self.events = []
        self.crashs = []
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
        loadEvents()
        loadCrashs()
    }
    
    func loadEvents() {
        
        let service = VaporNetworkService<VaporAnalyticEventModel>()
        
        // service.customFetch(limit: pageLimit, page: currentPage, appleIdentifierForVendor:appleIdentifierForVendor, appIdentifier:nil, appVersion:nil) { (serverEvents) in
        
        service.customFetch(limit: pageLimit, page: currentPage, appleIdentifierForVendor: appleIdentifierForVendor) { (serverEvents) in
            
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
    
    func loadCrashs() {
        
        let service = VaporNetworkService<VaporCrashEventModel>()
        // service.customFetch(limit: pageLimit, page: currentPage, appIdentifier: appIdentifier, appVersion:appVersion) { (serverCrashs) in
        service.customFetch(limit: pageLimit, page: currentPage, appleIdentifierForVendor: appleIdentifierForVendor) { (serverCrashs) in
            
            guard let serverCrashs = serverCrashs else { return }
            print( "serverCrashs.count \(serverCrashs.count)")
            
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
}
