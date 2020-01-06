//
//  CoreDataAnalyticEvent.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 10/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import CoreData

// CoreDataAnalyticEvent code generation is turned OFF in the xcdatamodeld file
public class CoreDataLocalEvent: NSManagedObject, Identifiable {
    
    @NSManaged public var name: String?
    
    @NSManaged public var dispatchTime: Date?
    
    @NSManaged public var localDeviceEventUUID: UUID?

    @NSManaged public var appIdentifier: String?
    
    @NSManaged public var appVersion: String?
    
    @NSManaged public var appBuildNumber: String?

    @NSManaged public var protectedMetaData: String?
    
    @NSManaged public var appMetaData: String?
    
    @NSManaged public var appUserIdentifier: String?

}

extension CoreDataLocalEvent {

    // The @FetchRequest property wrapper in the ContentView will call this function
    public static func allEventsFetchRequest() -> NSFetchRequest<CoreDataLocalEvent> {
        
        let request: NSFetchRequest<CoreDataLocalEvent> = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")
        
        //let request: NSFetchRequest<LocalSession> = LocalSession.fetchRequest() as! NSFetchRequest<LocalSession>
        
        // The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
}

