//
//  DataHelpers.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

class DataHelpers {
    
    static let sharedInstance = DataHelpers()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // get the bundle where our managed objects (e.g., Entry) reside, and make a managed object model from all of our objects.
        let bundle = NSBundle(forClass: Entry.self)
        guard let model = NSManagedObjectModel.mergedModelFromBundles([bundle]) else { fatalError("model not found") }
        
        // figure out where we'll put the persistent store.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = urls.last!.URLByAppendingPathComponent("EmojiDay.sqlite")
        
        // make our persistent store coordinator. associate our model with it, and add a sqllite persistent store.
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        // swiftlint:disable force_try
        try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        // swiftlint:enable force_try
        
        // finally, make a new context for this persistent store and return it
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
}

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
