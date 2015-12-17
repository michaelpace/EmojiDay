//
//  Entry.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/18/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

@objc(Entry)
class Entry: NSManagedObject, ManagedObjectType {
    
    // MARK: Properties
    
    var renderedText: String {
        var outputString = ""
        for value in self.sentences! {
            let sentence: Sentence = value as! Sentence
            if (sentence.isCompleted) {
                outputString.appendContentsOf(sentence.renderedText)
            }
        }
        
        return outputString
    }
    
    // MARK: ManagedObjectType
    
    static var entityName: String {
        return "Entry"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
    
    // MARK: ()
    
    static func makeTodayEntry() -> Entry {
        guard let entry = NSEntityDescription.insertNewObjectForEntityForName(Entry.entityName, inManagedObjectContext: DataHelpers.sharedInstance.managedObjectContext) as? Entry else {
            fatalError(":(")
        }
        entry.date = NSDate()
        
        return entry
    }
    
    func addSentenceWithPrefix(prefix: String, emoji: String?) {
        var sentence: Sentence?
        
        if let lastSentence = sentences?.lastObject as? Sentence {
            if (!lastSentence.isCompleted && DateHelpers.dateIsToday(date!)) {
                sentence = lastSentence
            }
        }
        
        if (sentence == nil) {
            sentence = NSEntityDescription.insertNewObjectForEntityForName(Sentence.entityName, inManagedObjectContext: DataHelpers.sharedInstance.managedObjectContext) as? Sentence
        }
        
        sentence!.prefix = prefix
        sentence!.emoji = emoji
        
        let mutableSentences = (sentences?.mutableCopy())!
        mutableSentences.addObject(sentence!)
        sentences = mutableSentences as? NSOrderedSet
    }
    
}
