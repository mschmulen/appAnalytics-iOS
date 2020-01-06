//
//  CoreDataCrashInfo.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import CoreData

// CoreDataAnalyticEvent code generation is turned OFF in the xcdatamodeld file
public class CoreDataCrashEvent: NSManagedObject, Identifiable {
    
    @NSManaged public var crashType:String?
    
    @NSManaged public var name: String?
    
    @NSManaged public var reason: String?
    
    @NSManaged public var dispatchTime: Date?
    
    @NSManaged public var localCrashUUID: UUID?
    
    @NSManaged public var callStack: String?
    
    @NSManaged public var appUserIdentifier: String?
}

extension CoreDataCrashEvent {

    // The @FetchRequest property wrapper in the ContentView will call this function
    public static func allCrashEventsFetchRequest() -> NSFetchRequest<CoreDataCrashEvent> {
        
        let request: NSFetchRequest<CoreDataCrashEvent> = NSFetchRequest<CoreDataCrashEvent>(entityName: "CoreDataCrashEvent")
        
        // The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        return request
    }
}

