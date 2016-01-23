//
//  EmojiString.swift
//  EmojiDay
//
//  Created by Michael Pace on 1/27/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//

import Foundation

struct EmojiString {

    // MARK: Properties

    private var emojiArr = [String](count: 3, repeatedValue: "_")
    private var nextIndex = 0

    var stringValue: String {
        return emojiArr.reduce("", combine: { (first: String, second: String) -> String in first + second })
    }

    // MARK: ()

    mutating func addEmoji(emoji: String) {
        emojiArr[nextIndex] = emoji
        nextIndex = min(nextIndex + 1, emojiArr.count - 1)
    }

    mutating func deleteOnce() {
        guard nextIndex > 0 else {
            return
        }
        nextIndex -= 1
        emojiArr[nextIndex] = "_"
    }
    
}