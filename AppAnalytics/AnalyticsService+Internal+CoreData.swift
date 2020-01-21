//
//  AnalyticsService+Internal+CoreData.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 1/21/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import CoreData

extension AnalyticsService {
    
    /**
     deleteLocalEventsOlderThan9Days
     */
    internal func deleteLocalEventsOlderThan9Days() {
        let daysToAdd = -9
        let now = Date()
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        
        guard let dateInThePast = Calendar.current.date(byAdding: dateComponent, to: now) else { return }
        
        deleteOldLocalEventsAfter(dateInThePast)
        // let twelveHoursInThePast = Date().addingTimeInterval(-43200)
        // deleteOldLocalEventsAfter(twelveHoursInThePast )
    }
    
    /**
     deleteOldLocalEvents
     delete any events older than x amount of days
     
     
     let twelveHoursInThePast = Date().addingTimeInterval(-43200)
     deleteOldLocalEventsAfter(twelveHoursInThePast )
     
     */
    internal func deleteOldLocalEventsAfter(_ someDateInThePast: Date ) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Thread.printCurrent("deleteOldLocalEvents")
            
            // background request
            let context = CoreDataManager.shared.backgroundContext
            let fetchRequest = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")
            //            let sort = NSSortDescriptor(key: "dispatchTime", ascending: true)
            //            fetchRequest.sortDescriptors = [sort]
            let nsDate = someDateInThePast as NSDate
            let predicate = NSPredicate(format: "(dispatchTime > %@)", nsDate);
            fetchRequest.predicate = predicate
            
            // dispatchTime
            
            let localEvents:[CoreDataLocalEvent]
            do{
                let models = try context.fetch(fetchRequest)
                localEvents = models
            }catch let fetchErr {
                print("❌ Failed to fetch Person:",fetchErr)
                localEvents = []
            }
            
            print( "localEvents \(localEvents.count)")
            
            for (_,event) in localEvents.enumerated() {
                
                print( "event \(event.name ?? "~")")
                // _ = CoreDataManager.shared.deleteEvent(localEvent)
            }
        }
    }
    
    
    //    internal func flushLocalEventsToServerBackground() {
    //
    //        DispatchQueue.global(qos: .userInitiated).async {
    //
    //            // Thread.printCurrent("flushLocalEventsToServerBackground")
    //
    //            // background request
    //            let context = CoreDataManager.shared.backgroundContext
    //            let fetchRequest = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")
    //            let sort = NSSortDescriptor(key: "dispatchTime", ascending: true)
    //            fetchRequest.sortDescriptors = [sort]
    //
    //            let localEvents:[CoreDataLocalEvent]
    //            do{
    //                let models = try context.fetch(fetchRequest)
    //                localEvents = models
    //            }catch let fetchErr {
    //                print("❌ Failed to fetch Person:",fetchErr)
    //                localEvents = []
    //            }
    //
    //            print( "localEvents \(localEvents.count)")
    //
    //            for (_,event) in localEvents.enumerated() {
    //
    //                print( "event \(event.name ?? "~")")
    ////                // print( "tokenBucket.tokenCount: \(tokenBucket.tokenCount)")
    ////                if self.tokenBucket.tokenCount > 0 {
    ////                    // MAS TODO this needs to be spun out in an asyc thread
    ////                    //tokenBucket.consume(1)
    ////                    if (self.tokenBucket.tryConsumeBlocking(1, until: Date().addingTimeInterval(0.1))) {
    ////                        // print( "sending event \(event.name ?? "~")")
    ////                        ServerDispatchServices.sendEventToServerAndDeleteFromCoreData(event)
    ////                    }
    ////                } else {
    ////                    //print( "tokenBucket is empty, must try again later")
    ////                }
    //            }
    //        }
    //    }
}
