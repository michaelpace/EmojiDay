//
//  Sentence.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/18/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

@objc(Sentence)
class Sentence: NSManagedObject, ManagedObjectType {

    // MARK: ManagedObjectType
    
    static var entityName: String {
        return "Sentence"
    }
    
    // MARK: Properties
    
    var isCompleted: Bool {
        return emoji != nil
    }
    
    var emojiStringValue: String {
        if isCompleted {
            return emoji!
        } else {
            return "____"
        }
    }
    
    var renderedText: String {
        return prefix! + " " + emojiStringValue + ". "
    }
    
    // MARK: NSManagedObject
    
    override func willChangeValueForKey(key: String) {
        super.willChangeValueForKey(key)
        
        entry?.willChangeValueForKey("sentences")
    }
    
    override func didChangeValueForKey(key: String) {
        super.didChangeValueForKey(key)
        
        entry?.didChangeValueForKey("sentences")
    }

}
