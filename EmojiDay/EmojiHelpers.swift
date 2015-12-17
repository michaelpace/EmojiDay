//
//  EmojiHelpers.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/30/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

func stringForEmoji(emoji: Int) -> String {
    return String(UnicodeScalar(emoji))
}