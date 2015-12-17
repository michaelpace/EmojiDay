//
//  DateHelpers.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/29/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

class DateHelpers {
    
    static func date(firstDate: NSDate, isSameDayAsDate secondDate: NSDate) -> Bool {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        let startOfFirstDate = calendar.startOfDayForDate(firstDate)
        let startOfSecondDate = calendar.startOfDayForDate(secondDate)
        let components = calendar.components(NSCalendarUnit.Day, fromDate:startOfFirstDate, toDate:startOfSecondDate, options: [])
        
        return components.day == 0
    }
    
    static func dateIsToday(date: NSDate) -> Bool {
        return DateHelpers.date(NSDate(), isSameDayAsDate:date)
    }
    
}