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
            // TODO
//            if (sentence.isCompleted) {
                outputString.appendContentsOf(sentence.renderedText)
//            }
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
        if let lastSentence = sentences?.lastObject as? Sentence {
            if !lastSentence.isCompleted && DateHelpers.dateIsToday(date!) {
                lastSentence.prefix = prefix
                lastSentence.emoji = emoji
                
                return
            }
        }
        
        let mutableSentences = sentences?.mutableCopy() as! NSMutableOrderedSet
        let newSentence = NSEntityDescription.insertNewObjectForEntityForName(Sentence.entityName, inManagedObjectContext: DataHelpers.sharedInstance.managedObjectContext) as! Sentence
        newSentence.prefix = prefix
        newSentence.emoji = emoji
        newSentence.entry = self
        mutableSentences.addObject(newSentence)
        sentences = mutableSentences.copy() as? NSOrderedSet
        try! DataHelpers.sharedInstance.managedObjectContext.save()
    }
    
    func heightGivenMaximumLineWidth(maximumLineWidth: CGFloat) -> CGFloat {
        // TODO: remove this logic. problems: (1) it is view code which doesn't belong in a model. (2) it works by mirroring logic in MSPTouchableLabel.
        // possible solution? give MSPTouchableLabel a class method which can report its size given a maximum line width.
        
        let remainingWords = renderedText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var numberOfLines = 1
        var currentLine = ""
        
        for var i = 0; i < remainingWords.count * 2; i++ {
            let currentLineSize = (currentLine as NSString).sizeWithAttributes(entryFontAttributes)
            
            let nextWord = i % 2 == 1 ? " " : remainingWords[i/2]
            let nextWordSize = (nextWord as NSString).sizeWithAttributes(entryFontAttributes)
            
            if currentLineSize.width + nextWordSize.width >= maximumLineWidth {
                numberOfLines += 1
                currentLine = ""
                if nextWord != " " {
                    currentLine += nextWord
                }
            } else {
                currentLine += nextWord
            }
        }
        
        let oneLineHeight = (renderedText as NSString).sizeWithAttributes(entryFontAttributes).height
        return oneLineHeight * CGFloat(numberOfLines)
    }
    
}
