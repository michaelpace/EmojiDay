//
//  EntryTableViewCell.swift
//  EmojiDay
//
//  Created by Michael Pace on 1/23/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//

import Foundation

class EntryTableViewCell: UITableViewCell, TableViewCellData {
    
    // MARK: - Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            let daysAgo = NSDate.daysBetweenDate((entry?.date)!, andDate: NSDate())
            let sForDaysAgo = daysAgo == 1 ? "" : "s"
            let date = (entry?.date?.prettyFormatted)!
            dateLabel.text = "\(daysAgo) day\(sForDaysAgo) ago | \(date)"
            
            entryLabel.text = entry?.renderedText
        }
    }
    
    // MARK: - TableViewCellData
    
    static var nibIdentifier: String {
        return "EntryTableViewCell"
    }

}