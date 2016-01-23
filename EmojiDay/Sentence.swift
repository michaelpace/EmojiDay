//
//  Sentence.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/18/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

public enum EmojiBlankState {
    case Completed
    case PartiallyCompleted
    case Blank
}

@objc(Sentence)
class Sentence: NSManagedObject, ManagedObjectType {

    // MARK: - ManagedObjectType
    
    static var entityName: String {
        return "Sentence"
    }
    
    // MARK: - Public properties

    var emojiState: EmojiBlankState {
        switch nextIndex {
        case emojis.count: return .Completed
        case 0: return .Blank
        default: return .PartiallyCompleted
        }
    }
    
    var renderedText: String {
        return prefix! + " " + emojiStringValue + ". "
    }

    // MARK: - Private properties

    private var emojis: [String?] {
        return [emoji1, emoji2, emoji3]
    }

    private var nextIndex: Int {
        return emojis.filter{ $0 != nil }.count
    }
    
    private var emojiStringValue: String {
        if nextIndex == 0 {
            return "___"
        }

        return emojis.reduce("", combine: {
            (first: String, second: String?) -> String in
            if let second = second {
                return first + second
            } else {
                return first
            }
        })
    }

    // MARK: - Public API
    
    func addEmoji(emojiToAdd: String?) {
        switch nextIndex {
        case 0: emoji1 = emojiToAdd
        case 1: emoji2 = emojiToAdd
        default: emoji3 = emojiToAdd
        }

        DataHelpers.save()
    }
    
    func deleteLastEmoji() {
        switch nextIndex {
        case 1: emoji1 = nil
        case 2: emoji2 = nil
        case 3: emoji3 = nil
        default: break
        }

        DataHelpers.save()
    }

}
