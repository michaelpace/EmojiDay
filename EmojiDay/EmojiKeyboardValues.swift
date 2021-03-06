//
//  EmojiKeyboardValues.swift
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
    var selectedIcon: UIImage
}

struct EmojiKeyboardEmoji {
    var value: String
    var variations: [String]
}

class EmojiKeyboardValues: NSObject, EmojiKeyboardDataSource {
    
    // MARK: - Properties
    
    static let sharedInstance = EmojiKeyboardValues()
    var sections = [EmojiKeyboardSection]()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        var plistSections: [[String: AnyObject]]
        if let path = NSBundle.mainBundle().pathForResource("EmojiKeyboardValues", ofType: "plist"), arr = NSArray(contentsOfFile: path) as? [[String: AnyObject]] {
            plistSections = arr
        } else {
            plistSections = [[String: AnyObject]]()
        }
        parsePlistWithSections(plistSections)
    }
    
    // MARK: - Private implementation
    
    private func parsePlistWithSections(plistSections: [[String: AnyObject]]) {
        for section: Dictionary in plistSections {
            
            guard let emojisArray = section["emojis"] as? [[String: AnyObject]] else {
                continue
            }

            var emojis = [EmojiKeyboardEmoji]()
            
            for emojiDict: Dictionary in emojisArray {
                guard let
                    value = emojiDict["emoji"] as? String,
                    variations = emojiDict["variations"] as? [String] else {
                    continue
                }
                
                let emojiKeyboardEmoji = EmojiKeyboardEmoji(value: value, variations: variations)
                emojis.append(emojiKeyboardEmoji)
            }
            
            guard let
                title = section["title"] as? String,
                icon = UIImage(named: title) else {
                continue
            }
            
            let emojiKeyboardSection = EmojiKeyboardSection(title: title, emojis: emojis, icon: icon, selectedIcon: icon)
            sections.append(emojiKeyboardSection)
        }
    }
    
    // MARK: - EmojiKeyboardDataSource
    
    func sectionsForEmojiKeyboard(emojiKeyboard: EmojiKeyboard) -> [EmojiKeyboardSection] {
        return sections
    }
    
}
