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
    
    // MARK: Properties
    
    var delegate: SentenceChooserDelegate?
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let prefixes = SentenceDirectory.sharedInstance.allPrefixes
        var x = CGFloat(0)
        
        for prefix: String in prefixes {
            let button = UIButton(type: UIButtonType.RoundedRect)
            button.frame = CGRectMake(x, 16, 64, 48)
            button.setTitle(prefix, forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            addSubview(button)
            x += button.bounds.width
        }
    }
    
    // MARK: Actions
    
    func buttonTapped(sender: AnyObject) {
        guard delegate != nil else {
            return
        }
        
        let button = sender as! UIButton
        let sentence = button.titleForState(UIControlState.Normal)!
        
        delegate?.sentenceChosen(sentence)
    }
    
}