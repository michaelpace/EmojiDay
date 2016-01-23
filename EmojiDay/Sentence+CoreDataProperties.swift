//
//  Sentence+CoreDataProperties.swift
//  EmojiDay
//
//  Created by Michael Pace on 1/27/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sentence {

    @NSManaged var emoji1: String?
    @NSManaged var prefix: String?
    @NSManaged var emoji2: String?
    @NSManaged var emoji3: String?
    @NSManaged var entry: Entry?

}
