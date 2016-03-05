//
//  SentenceChooser.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

protocol SentenceChooserDelegate: NSObjectProtocol {
    func sentenceChosen(sentence: String)
}

class SentenceChooser: UIView {
    
    // MARK: - Properties
    
    var delegate: SentenceChooserDelegate?
    let prefixes = ["Saw", "Ate", "Visited", "Made", "Talked to", "Bought"]
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x = CGFloat(0)
        
        for prefix in prefixes {
            let button = UIButton(type: UIButtonType.RoundedRect)
            button.frame = CGRect(x: x, y: 16, width: 64, height: 48)
            button.setTitle(prefix, forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            addSubview(button)
            x += button.bounds.width
        }
    }
    
    // MARK: - Actions
    
    func buttonTapped(sender: AnyObject) {
        guard delegate != nil,
            let button = sender as? UIButton else {
                return
        }
        
        if let sentence = button.titleForState(UIControlState.Normal) {
            delegate?.sentenceChosen(sentence)
        }
    }
    
}
