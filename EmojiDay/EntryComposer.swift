//
//  EntryComposer.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

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
    var currentSentence: Sentence?
    
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
        return entryFontAttributes
    }
    
    // MARK: MSPTouchableLabelDelegate
    
    func touchableLabel(touchableLabel: MSPTouchableLabel!, touchesDidEndAtIndex index: Int) {
        currentSentence = entry?.sentences![index] as? Sentence
        let validEmoji: [String] = SentenceDirectory.sharedInstance[currentSentence!.prefix!]
        emojiKeyboard!.keys = validEmoji
        hiddenTextView.becomeFirstResponder()
    }
    
    // MARK: EmojiKeyboardDelegate
    
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String) {
        currentSentence?.emoji = text
        try! DataHelpers.sharedInstance.managedObjectContext.save()
    }
    
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard) {}
    
}