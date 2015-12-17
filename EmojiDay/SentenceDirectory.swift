//
//  SentenceDirectory.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/30/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

class SentenceDirectory {
    
    // MARK: Properties
    
    static let sharedInstance = SentenceDirectory()
    var directory: [[String: AnyObject]]
    var allPrefixes: [String] {
        var result = [String]()

        for sentence: [String: AnyObject] in directory {
            result.append(sentence["prefix"] as! String)
        }
        
        return result
    }
    
    // MARK: Initialization
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("SentenceDirectory", ofType: "plist"), arr = NSArray(contentsOfFile: path) as? [[String: AnyObject]] {
            directory = arr
        } else {
            directory = [[String: AnyObject]]()
        }
    }
    
    // MARK: Subscript
    
    subscript(index: String) -> [String] {
        
        get {
            for sentence: [String: AnyObject] in directory {
                let prefix = sentence["prefix"] as! String
                if (prefix == index) {
                    return sentence["emojis"] as! [String]
                }
            }
            
            return [String]()
        }
        
    }
    
}