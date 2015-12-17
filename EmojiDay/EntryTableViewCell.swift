//
//  EntryTableViewCell.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

class EntryTableViewCell: UITableViewCell, TableViewCellData {
    
    // MARK: Properties
    
    var entry: Entry? {
        didSet {
            entryComposer.entry = entry
        }
    }
    var liveEntry: Bool = false {
        didSet {
            entryComposer.liveEntry = liveEntry
        }
    }
    
    @IBOutlet weak var entryComposerWrapperView: UIView!
    var entryComposer: EntryComposer = NSBundle.mainBundle().loadNibNamed("EntryComposer", owner: nil, options: nil).first as! EntryComposer
    
    // MARK: UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        entryComposer.frame = entryComposerWrapperView.bounds
        entryComposerWrapperView.addSubview(entryComposer)
    }
    
    // MARK: TableViewCellData
    
    static var nibIdentifier: String {
        return "EntryTableViewCell"
    }
    
}