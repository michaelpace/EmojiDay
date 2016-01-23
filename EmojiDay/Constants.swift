//
//  Constants.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/16/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import UIKit

enum ColorScheme {
    case AccentColor
    case UnselectedColor
    
    func color() -> UIColor {
        switch self {
        case .AccentColor:
            return UIColor(colorLiteralRed: 0.0/255.0,
                green: 189.0/255.0,
                blue: 242.0/255.0,
                alpha: 1.0)
        case .UnselectedColor:
            return UIColor(colorLiteralRed: 188.0/255.0,
                green: 190.0/255.0,
                blue: 192.0/255.0,
                alpha: 1.0)
        }
    }
}

let entryFontAttributes: [String: AnyObject] = [
    NSFontAttributeName: UIFont.boldSystemFontOfSize(24.0),
    NSForegroundColorAttributeName: ColorScheme.AccentColor.color(),
]