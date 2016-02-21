//
//  DataManager.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Data Helpers

class DataManager {
    
    static let sharedInstance = DataManager()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // get the bundle where our managed objects (e.g., Entry) reside, and make a managed object model (schema) from all of our objects.
        let bundle = NSBundle(forClass: Entry.self)
        guard let model = NSManagedObjectModel.mergedModelFromBundles([bundle]) else { fatalError("model not found") }
        
        // figure out where we'll put the persistent store.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = urls.last!.URLByAppendingPathComponent("EmojiDay.sqlite")
        
        // make our persistent store coordinator. associate our model with it, and add a sqllite persistent store.
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        
        // finally, make our managed object context and return it.
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }()
    
    static func save() {
        try! sharedInstance.managedObjectContext.save()
    }
}

// MARK: - ManagedObjectType

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension ManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}
