//
//  EntryTableViewCell.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

private let entryComposerWrapperViewConstraintConstant = CGFloat(32.0)

class EntryTableViewCell: UITableViewCell, TableViewCellData {
    
    // MARK: Properties
    
    var entry: Entry? {
        didSet {
            entryComposer.entry = entry
            dateLabel.text = entry?.date?.prettyFormatted
        }
    }
    
    var liveEntry: Bool = false {
        didSet {
            entryComposer.liveEntry = liveEntry
        }
    }
    
    class var heightOfCellWithNoContent: CGFloat {
        return entryComposerWrapperViewConstraintConstant * 2
    }
    
    var entryComposer: EntryComposer = NSBundle.mainBundle().loadNibNamed("EntryComposer", owner: nil, options: nil).first as! EntryComposer
    
    @IBOutlet weak var entryComposerWrapperView: UIView!
    @IBOutlet weak var entryComposerWrapperViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryComposerWrapperViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryComposerWrapperViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        entryComposerWrapperViewLeadingConstraint.constant = entryComposerWrapperViewConstraintConstant
        entryComposerWrapperViewTrailingConstraint.constant = entryComposerWrapperViewConstraintConstant
        entryComposerWrapperViewBottomConstraint.constant = entryComposerWrapperViewConstraintConstant
        
        entryComposer.frame = entryComposerWrapperView.bounds
        entryComposerWrapperView.addSubview(entryComposer)
    }
    
    // MARK: TableViewCellData
    
    static var nibIdentifier: String {
        return "EntryTableViewCell"
    }
    
    // MARK: ()
    
    class func widthOfEntryComposerGivenTableView(tableView: UITableView) -> CGFloat {
        return tableView.bounds.width - (entryComposerWrapperViewConstraintConstant * 2)
    }
    
}
