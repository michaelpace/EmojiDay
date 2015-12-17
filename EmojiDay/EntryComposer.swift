//
//  EntryComposer.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

/*

rules:
- select most recent blank.
    - tap to add emoji to blank.
    - backspace to delete emoji, or if no emoji (== !sentence.isCompleted), the sentence.
- drag sentences to rearrange.

*/

import Foundation

class EntryComposer: UIView, MSPTouchableLabelDataSource, MSPTouchableLabelDelegate, EmojiKeyboardDelegate {
    
    // MARK: Properties
    
    var entry: Entry? {
        didSet {
            touchableLabel.setNeedsDisplay()
        }
    }
    @IBOutlet weak var touchableLabel: MSPTouchableLabel!
    var liveEntry: Bool = false
    var emojiKeyboard: EmojiKeyboard?
    let hiddenTextView = UITextView()
    
    // MARK: UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        touchableLabel.dataSource = self
        touchableLabel.delegate = self
        
        emojiKeyboard = NSBundle.mainBundle().loadNibNamed("EmojiKeyboard", owner: self, options: nil).first as? EmojiKeyboard
        emojiKeyboard!.delegate = self
        emojiKeyboard!.backgroundColor = UIColor(colorLiteralRed: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        emojiKeyboard!.accentColor = accentColor
        hiddenTextView.inputView = emojiKeyboard
        hiddenTextView.hidden = true
        addSubview(hiddenTextView)
    }
    
    // MARK: MSPTouchableLabelDataSource
    
    func textForTouchableLabel(touchableLabel: MSPTouchableLabel!) -> [AnyObject]! {
        guard liveEntry else {
            return [(entry?.renderedText)!]
        }
        
        var outputText = [String]()
        for sentence: Sentence in (entry?.sentences?.array) as! [Sentence] {
            outputText.append(sentence.renderedText)
        }
        
        return outputText
    }
    
    func attributesForTouchableLabel(touchableLabel: MSPTouchableLabel!, atIndex index: Int) -> [NSObject : AnyObject]! {
        return [String: String]()
    }
    
    // MARK: MSPTouchableLabelDelegate
    
    func touchableLabel(touchableLabel: MSPTouchableLabel!, touchesDidEndAtIndex index: Int) {
        let sentence: Sentence = entry?.sentences![index] as! Sentence
        let validEmoji: [String] = SentenceDirectory.sharedInstance[sentence.prefix!]
        emojiKeyboard!.keys = validEmoji
        hiddenTextView.becomeFirstResponder()
    }
    
    // MARK: EmojiKeyboardDelegate
    
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String) {}
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard) {}
    
}