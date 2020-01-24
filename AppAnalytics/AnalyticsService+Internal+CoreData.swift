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
     deleteOldLocalEvents
     delete any events older than x amount of days
     
     Usage:
     let now = Date()
     var dateComponent = DateComponents()
     dateComponent.day = -9 // 9 days in the past
     guard let dateInThePast = Calendar.current.date(byAdding: dateComponent, to: now) else { return }
     deleteLocalEventsOderThan( someDateInThePast: dateInThePast)     
     */
    internal func deleteLocalEventsOderThan( someDateInThePast: Date ) {
        // print("deleteLocalEventsOderThan \(someDateInThePast)")
        DispatchQueue.global(qos: .userInitiated).async {
            // Thread.printCurrent("deleteOldLocalEvents")
            
            let context = CoreDataManager.shared.backgroundContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataLocalEvent")
            let nsDate = someDateInThePast as NSDate
            let predicate = NSPredicate(format: "(dispatchTime < %@)", nsDate);
            fetchRequest.predicate = predicate
            
            //build a delete request to support batch delete
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            // Configure Batch Update Request
            batchDeleteRequest.resultType = .resultTypeCount
            
            do {
                // Execute Batch Request
                let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
                print("The batch delete request has deleted \(batchDeleteResult.result!) records")
            } catch {
                let updateError = error as NSError
                print("batchDeleteRequest error: \(updateError), \(updateError.userInfo)")
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
