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
    
    // MARK: - Public properties
    
    var renderedText: String {
        var outputString = ""
        guard let sentencesToRender = sentences?.array else {
            return outputString
        }
        
        for value in sentencesToRender {
            let sentence = value as? Sentence
            if sentence != nil && sentence?.emojiState != .Blank {
                outputString.appendContentsOf(sentence!.renderedText)
            }
        }
        
        return outputString
    }
    
    // MARK: - ManagedObjectType
    
    static var entityName: String {
        return "Entry"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
    
    // MARK: - Public API
    
    static func makeTodayEntry() -> Entry {
        guard let entry = NSEntityDescription.insertNewObjectForEntityForName(Entry.entityName, inManagedObjectContext: DataHelpers.sharedInstance.managedObjectContext) as? Entry else {
            fatalError(":(")
        }
        entry.date = NSDate()
        
        return entry
    }
    
    func addSentenceWithPrefix(prefix: String, emoji: String?) {
        if let lastSentence = sentences?.lastObject as? Sentence {
            if lastSentence.emojiState == EmojiBlankState.Blank && NSDate.dateIsToday(date!) {
                lastSentence.prefix = prefix
                lastSentence.addEmoji(emoji)
                
                return
            }
        }
        
        let mutableSentences = sentences?.mutableCopy() as! NSMutableOrderedSet
        let newSentence = NSEntityDescription.insertNewObjectForEntityForName(Sentence.entityName, inManagedObjectContext: DataHelpers.sharedInstance.managedObjectContext) as! Sentence
        newSentence.prefix = prefix
        newSentence.addEmoji(emoji)
        newSentence.entry = self
        mutableSentences.addObject(newSentence)
        sentences = mutableSentences.copy() as? NSOrderedSet

        DataHelpers.save()
    }
    
    func deleteSentence(sentenceToDelete: Sentence) {
        guard sentences?.count > 0 else {
            return
        }
        
        let mutableSentences = sentences?.mutableCopy() as? NSMutableOrderedSet
        mutableSentences?.removeObject(sentenceToDelete)
        sentences = mutableSentences
        DataHelpers.sharedInstance.managedObjectContext.deleteObject(sentenceToDelete)

        DataHelpers.save()
    }
    
    func moveSentenceAtIndex(startingIndex: Int, var toIndex endingIndex: Int) {
        guard sentences?.count > 0 else {
            return
        }
        if endingIndex >= sentences!.count {
            endingIndex = sentences!.count - 1
        }
        
        let mutableSentences = sentences?.mutableCopy() as? NSMutableOrderedSet
        mutableSentences?.moveObjectsAtIndexes(NSIndexSet(index: startingIndex), toIndex: endingIndex)
        
        sentences = mutableSentences

        DataHelpers.save()
    }
    
    func heightGivenMaximumLineWidth(maximumLineWidth: CGFloat) -> CGFloat {
        let result = MSPTouchableLabel.sizeForTouchableLabelGivenText(
            sentences?.map{ $0.renderedText },
            withAttributes: [[String: AnyObject]](count: (sentences?.count == nil ? 0 : (sentences?.count)!), repeatedValue: entryFontAttributes),
            inRect: CGRect(
                origin: CGPointZero,
                size: CGSize(
                    width: maximumLineWidth,
                    height: CGFloat(INT16_MAX))))

        return result.height
    }
    
}
