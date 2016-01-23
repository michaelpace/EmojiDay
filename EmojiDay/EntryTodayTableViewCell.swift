//
//  EntryTodayTableViewCell.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

private let entryComposerWrapperViewConstraintConstant = CGFloat(32.0)

class EntryTodayTableViewCell: UITableViewCell, TableViewCellData {
    
    // MARK: - Public properties
    
    var entry: Entry? {
        didSet {
            let date = (entry?.date?.prettyFormatted)!
            dateLabel.text = "Today | \(date)"
            
            entryComposer.entry = entry
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

    // MARK: - Private properties

    private var entryComposer: EntryComposer = NSBundle.mainBundle().loadNibNamed("EntryComposer", owner: nil, options: nil).first as! EntryComposer
    @IBOutlet private weak var entryComposerWrapperView: UIView!
    @IBOutlet private weak var entryComposerWrapperViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var entryComposerWrapperViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var entryComposerWrapperViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        entryComposerWrapperViewLeadingConstraint.constant = entryComposerWrapperViewConstraintConstant
        entryComposerWrapperViewTrailingConstraint.constant = entryComposerWrapperViewConstraintConstant
        entryComposerWrapperViewBottomConstraint.constant = entryComposerWrapperViewConstraintConstant
        
        entryComposer.frame = entryComposerWrapperView.bounds
        entryComposerWrapperView.addSubview(entryComposer)
    }
    
    // MARK: - TableViewCellData
    
    static var nibIdentifier: String {
        return "EntryTodayTableViewCell"
    }
    
    // MARK: - Public API
    
    class func widthOfEntryComposerGivenTableView(tableView: UITableView) -> CGFloat {
        return tableView.bounds.width - (entryComposerWrapperViewConstraintConstant * 2)
    }

}
