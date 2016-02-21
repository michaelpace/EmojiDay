//
//  DataSource.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

public protocol DataSourceDelegate {
    func contentDidChange()
}

class DataSource: NSObject, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    var fetchedResultsController: NSFetchedResultsController
    var delegate: DataSourceDelegate
    var fetchedObjects: Array<AnyObject> {
        guard let content = fetchedResultsController.fetchedObjects else {
            fatalError("no")
        }
        
        return content
    }
    
    // MARK: - Initializers
    
    init(fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext, delegate: DataSourceDelegate) {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = delegate
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(":(")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate.contentDidChange()
    }
    
}
