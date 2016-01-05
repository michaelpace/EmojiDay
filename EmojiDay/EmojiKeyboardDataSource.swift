//
//  EmojiKeyboardDataSource.swift
//  EmojiDay
//
//  Created by Michael Pace on 1/6/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//

import Foundation

struct EmojiKeyboardSection {
    var title: String
    var emojis: [EmojiKeyboardEmoji]
    var icon: UIImage
}

struct EmojiKeyboardEmoji {
    var emoji: String
    var variations: [String]
}

class EmojiKeyboardDataSource {
    
    // MARK: Properties
    
    static let sharedInstance = EmojiKeyboardDataSource()
    var plistSections: [[String: AnyObject]]
    var sections = [EmojiKeyboardSection]()
    
    // MARK: Initialization
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("EmojiKeyboardValues", ofType: "plist"), arr = NSArray(contentsOfFile: path) as? [[String: AnyObject]] {
            plistSections = arr
        } else {
            plistSections = [[String: AnyObject]]()
        }
        
        parsePlist()
    }
    
    // MARK: ()
    
    private func parsePlist() {
        for section: Dictionary in plistSections {
            
            let emojisArray: [[String: AnyObject]] = section["emojis"] as! [[String: AnyObject]]
            var emojis = [EmojiKeyboardEmoji]()
            
            for emojiDict: Dictionary in emojisArray {
                let emoji = emojiDict["emoji"] as! String
                let variations = emojiDict["variations"] as! [String]
                
                let emojiKeyboardEmoji = EmojiKeyboardEmoji(emoji: emoji, variations: variations)
                emojis.append(emojiKeyboardEmoji)
            }
            
            let title: String = section["title"] as! String
            let icon: UIImage = UIImage.init(named: title)!
            
            let emojiKeyboardSection = EmojiKeyboardSection(title: title, emojis: emojis, icon: icon)
            sections.append(emojiKeyboardSection)
        }
    }
}