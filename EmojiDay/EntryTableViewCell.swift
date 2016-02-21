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
            guard let date = entry?.date else {
                return
            }
            let daysAgo = NSDate.daysBetweenDate(date, andDate: NSDate())
            let sForDaysAgo = daysAgo == 1 ? "" : "s"
            let formattedDate = date.prettyFormatted
            dateLabel.text = "\(daysAgo) day\(sForDaysAgo) ago | \(formattedDate)"
            
            entryLabel.text = entry?.renderedText
        }
    }
    
    // MARK: - TableViewCellData
    
    static var nibIdentifier: String {
        return "EntryTableViewCell"
    }

}