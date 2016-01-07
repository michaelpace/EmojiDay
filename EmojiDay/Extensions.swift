//
//  Extensions.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/16/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func rgb() -> (red: Float, green: Float, blue: Float, alpha: Float)? {
        // from http://stackoverflow.com/questions/28644311/howto-get-the-rgb-code-int-from-an-uicolor-in-swift
        
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red:Float(fRed), green:Float(fGreen), blue:Float(fBlue), alpha:Float(fAlpha))
        } else {
            return nil
        }
    }
}

extension NSDate {
    var prettyFormatted: String {
        return formattedWith("EEEE, LLL. dd, yyyy")
    }
    
    func formattedWith(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
}
