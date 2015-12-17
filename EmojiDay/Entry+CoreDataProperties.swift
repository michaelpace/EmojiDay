//
//  Entry+CoreDataProperties.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/30/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entry {

    @NSManaged var date: NSDate?
    @NSManaged var sentences: NSOrderedSet?

}
