//
//  AnalyticsService+Analytics.swift
//

import Foundation

extension AnalyticsService {
    
    /**
     This is the public entry point to dispatch an analytic event.
     It will store the data in local storage first and then call an attemptToFlushLocalData which is rate limited by the TokenBucket. The TokenBucket allows rate limiting of dispatched events in a deterministic way without relying on timers.
     */
    public class func dispatchAnalyticEvent(_ event:AnalyticEvent, appMetaData: [String:String] = [:]){
        let protectedMetaData:[String:String] = [:]
        CoreDataManager.shared.createEvent(
            name: event.name,
            dispatchTime: Date(),
            protectedMetaData: protectedMetaData,
            appMetaData: appMetaData
        )
        AnalyticsService.shared().attemptToFlushLocalData()
    }
    
    /**
     This is the public entry point to dispatch an analytic event.
     It will store the data in local storage first and then call an attemptToFlushLocalData which is rate limited by the TokenBucket. The TokenBucket allows rate limiting of dispatched events in a deterministic way without relying on timers.
     */
    public class func dispatchAnalyticEvent(_ event:AnalyticEventProtocol, appMetaData: [String:String] = [:]){
        let protectedMetaData:[String:String] = [:]
        CoreDataManager.shared.createEvent(
            name: event.name,
            dispatchTime: Date(),
            protectedMetaData: protectedMetaData,
            appMetaData: appMetaData
        )
        AnalyticsService.shared().attemptToFlushLocalData()
    }
    
    /// internal frawework for Private analytics such as `didFinishLaunchingWithOptions`
    internal class func dispatchAnalyticEvent(_ event:PrivateAnalyticEvent, appMetaData: [String:String] = [:]){
        let protectedMetaData:[String:String] = [:]
        CoreDataManager.shared.createEvent(
            name: event.name,
            dispatchTime: Date(),
            protectedMetaData: protectedMetaData,
            appMetaData: appMetaData
        )
        AnalyticsService.shared().attemptToFlushLocalData()
    }
    
}


