//
//  EntryTodayTableViewCell.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

private let entryComposerWrapperViewBottomConstraintConstant: CGFloat = 40
private let entryComposerWrapperViewLeftRightConstraintConstant: CGFloat = 16

class EntryTodayTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    var entry: Entry? {
        didSet {
            guard let date = entry?.date?.prettyFormatted else {
                return
            }
            dateLabel.text = "Today | \(date)"
            
            entryComposer.entry = entry
        }
    }

    class var heightOfCellWithNoContent: CGFloat {
        return entryComposerWrapperViewBottomConstraintConstant * 2
    }

    // MARK: - Private properties

    private var entryComposer: EntryComposer!
    @IBOutlet private weak var entryComposerWrapperView: UIView!
    @IBOutlet private weak var entryComposerWrapperViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var entryComposerWrapperViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var entryComposerWrapperViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()

        guard let entryComposer = NSBundle.mainBundle().loadNibNamed("EntryComposer", owner: nil, options: nil).first as? EntryComposer else {
            fatalError()
        }

        entryComposerWrapperViewLeadingConstraint.constant = entryComposerWrapperViewLeftRightConstraintConstant
        entryComposerWrapperViewTrailingConstraint.constant = entryComposerWrapperViewLeftRightConstraintConstant
        entryComposerWrapperViewBottomConstraint.constant = entryComposerWrapperViewBottomConstraintConstant
        
        entryComposer.frame = entryComposerWrapperView.bounds
        entryComposerWrapperView.addSubview(entryComposer)

        self.entryComposer = entryComposer
    }
}

// MARK: - TableViewCellData

extension EntryTodayTableViewCell: TableViewCellData {
    static var nibIdentifier: String {
        return "EntryTodayTableViewCell"
    }
}

// MARK: - Public API

extension EntryTodayTableViewCell {
    class func widthOfEntryComposerGivenTableView(tableView: UITableView) -> CGFloat {
        return tableView.bounds.width - (entryComposerWrapperViewLeftRightConstraintConstant * 2)
    }

    func selectLastSentence() {
        entryComposer.selectLastSentence()
        entryComposer.showKeyboard()
    }

    func hideKeyboard() {
        entryComposer.hideKeyboard()
    }
}
