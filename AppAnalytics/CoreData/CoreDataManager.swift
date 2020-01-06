//
//  CoreDataManager.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 10/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import CoreData

/// CoreDataManager
/// Usage:
/// CoreDataManager.shared.createSession()
///
///
/// CoreDataManager.shared.createEvent(name: "viewDidShow", sessionUUID: someUUID, dispatchTime:Date )
///
public class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    let identifier: String  = "com.jumptack.AppAnalytics"       // framework bundle ID
    let modelName: String       = "AppAnalytics"                // xcdatamodelid Model name

    /// pesistentContainer
    public lazy var persistentContainer: NSPersistentContainer = {
        
        //let container = NSPersistentCloudKitContainer(name: "YackAnalytics")
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.modelName, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.modelName, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        
        // container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // container.viewContext.undoManager = nil
        // container.viewContext.shouldDeleteInaccessibleFaults = true
        // container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
//    /// privateContext background context not `main`
//    public lazy var privateContext:NSManagedObjectContext = {
//        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        return moc
//    }()
    
    // Work in progress for background saving otherwise everything is on the main thread in the viewContext
    // public var backgroundContext:NSManagedObjectContext?
    public lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
}

// CrashEvent
extension CoreDataManager {

    /// Create an event for dispatch to local storage
    internal func createCrashEvent(
        type:String,
        name: String,
        reason: String,
        callStack:String,
        dispatchTime: Date        
    ){
        
        let context = persistentContainer.viewContext
        let model = NSEntityDescription.insertNewObject(forEntityName: "CoreDataCrashEvent", into: context) as! CoreDataCrashEvent
        
        model.name  = name
        model.crashType = type
        model.reason = reason
        model.callStack = callStack
        model.localCrashUUID = UUID()
        model.dispatchTime = dispatchTime
        model.appUserIdentifier = AnalyticsService.shared().appUserIdentifier
        
        do {
            try context.save()
            // print("✅ Event saved succesfuly")
        } catch let error {
            print("❌ Failed to create Event: \(error.localizedDescription)")
        }
    }
    
    internal func deleteCrashEvent(_ localEvent:CoreDataCrashEvent) -> Bool {
        persistentContainer.viewContext.delete(localEvent)
        do {
            try persistentContainer.viewContext.save()
            // print("✅ save context")
        } catch let error {
            print("❌ Failed save context \(error)")
        }

        return true
    }
    
    internal func fetchLocalCrashEventsOldestFirst() -> [CoreDataCrashEvent] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataCrashEvent>(entityName: "CoreDataCrashEvent")
        let sort = NSSortDescriptor(key: "dispatchTime", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do{
            let models = try context.fetch(fetchRequest)
            return models
        }catch let fetchErr {
            print("❌ Failed to fetch Person:",fetchErr)
            return []
        }
    }
    
}


// LocalAnalyticEvent
extension CoreDataManager {

    /// Create an event for dispatch to local storage
    internal func createEvent(
        name: String,
        dispatchTime: Date,
        protectedMetaData: [String:String],
        appMetaData: [String:String]
    ){
        
        let context = persistentContainer.viewContext
        let model = NSEntityDescription.insertNewObject(forEntityName: "CoreDataLocalEvent", into: context) as! CoreDataLocalEvent
        
        model.name  = name
        model.dispatchTime = Date()
        model.localDeviceEventUUID = UUID()
        model.appIdentifier = AnalyticsService.shared().appInfo.bundleIdentifier
        model.appVersion = AnalyticsService.shared().appInfo.bundleShortVersion
        model.appBuildNumber = AnalyticsService.shared().appInfo.bundleVersion
        model.appMetaData = "\(appMetaData)"
        model.protectedMetaData = "\(protectedMetaData)"
        model.appUserIdentifier = AnalyticsService.shared().appUserIdentifier
        
        // MAS TODO stringify the appMetaData and the protectedMetaData for coreData
        
        do {
            try context.save()
            // print("✅ Event saved succesfuly")
        } catch let error {
            print("❌ Failed to create Event: \(error.localizedDescription)")
        }
    }
    
    /// fetch an event from local storage
    internal func fetchEvent(){
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")

        do{
            let models = try context.fetch(fetchRequest)
            for (index,model) in models.enumerated() {
                print("Model \(index): \(String(describing: model.name))")
                print(" dispatchTime: \( String(describing:model.dispatchTime)) ")
            }
            
        }catch let fetchErr {
            print("❌ Failed to fetch Person:",fetchErr)
        }
    }
    
    internal func fetchLocalEventsOldestFirst() -> [CoreDataLocalEvent] {
        
        // Thread.printCurrent("fetchLocalEventsOldestFirst")
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")
        let sort = NSSortDescriptor(key: "dispatchTime", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do{
            let models = try context.fetch(fetchRequest)
            return models
        }catch let fetchErr {
            print("❌ Failed to fetch Person:",fetchErr)
            return []
        }
    }
    
    public func fetchLocalEvents() -> [CoreDataLocalEvent] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")
        do{
            let models = try context.fetch(fetchRequest)
            return models
        }catch let fetchErr {
            print("❌ Failed to fetch Person:",fetchErr)
            return []
        }
    }
    
    internal func deleteEvent(_ localEvent:CoreDataLocalEvent) -> Bool {
        persistentContainer.viewContext.delete(localEvent)
        do {
            try persistentContainer.viewContext.save()
            // print("✅ save context")
        } catch let error {
            print("❌ Failed save context \(error)")
        }

        return true
    }

}
