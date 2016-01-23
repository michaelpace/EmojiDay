//
//  EntryComposer.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

class EntryComposer: UIView, MSPTouchableLabelDataSource, MSPTouchableLabelDelegate, EmojiKeyboardDelegate {
    
    // MARK: - Public properties
    
    var entry: Entry? {
        didSet {
            sentences = entry?.sentences?.array as? [Sentence]
            touchableLabel.setNeedsDisplay()
        }
    }
    var liveEntry: Bool = false

    // MARK: - Private properties

    private var sentences: [Sentence]?
    private let hiddenTextView = UITextView()
    private var emojiKeyboard: EmojiKeyboard!
    private var selectedSentence: Sentence?
    @IBOutlet private weak var touchableLabel: MSPTouchableLabel!
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        touchableLabel.dataSource = self
        touchableLabel.delegate = self
        
        emojiKeyboard = NSBundle.mainBundle().loadNibNamed("EmojiKeyboard", owner: self, options: nil).first as? EmojiKeyboard
        emojiKeyboard.delegate = self
        emojiKeyboard.backgroundColor = UIColor(colorLiteralRed: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        emojiKeyboard.accentColor = ColorScheme.AccentColor.color()
        emojiKeyboard.unselectedColor = ColorScheme.UnselectedColor.color()
        emojiKeyboard.showRecentSection = false
        hiddenTextView.inputView = emojiKeyboard
        hiddenTextView.hidden = true
        addSubview(hiddenTextView)
    }
    
    // MARK: - MSPTouchableLabelDataSource
    
    func textForTouchableLabel(touchableLabel: MSPTouchableLabel!) -> [AnyObject]! {
        var outputText = [String]()
        
        guard sentences?.count > 0 else {
            return outputText
        }
        
        for i in 0..<(sentences?.count)! {
            let sentence = sentences![i]
            outputText.append(sentence.renderedText)
        }
        
        return outputText
    }
    
    func attributesForTouchableLabel(touchableLabel: MSPTouchableLabel!, atIndex index: Int) -> [NSObject : AnyObject]! {
        var result = entryFontAttributes
        if let s = sentences {
            let sentenceAtIndexInQuestion = s[index]
            if sentenceAtIndexInQuestion == selectedSentence {
                result[NSBackgroundColorAttributeName] = UIColor.yellowColor()
            }
        }

        return result
    }
    
    // MARK: - MSPTouchableLabelDelegate
    
    func touchableLabel(touchableLabel: MSPTouchableLabel!, touchesDidEndAtIndex index: Int) {
        hiddenTextView.becomeFirstResponder()
        selectedSentence = sentences![index]
    }
    
    // MARK: - EmojiKeyboardDelegate
    
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String) {
        selectedSentence?.addEmoji(text)
        touchableLabel.setNeedsDisplay()
    }
    
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard) {
        if selectedSentence?.emojiState == EmojiBlankState.Blank {
            entry?.deleteSentence(selectedSentence!)
            selectedSentence = sentences![sentences!.count-1]
        } else {
            selectedSentence?.deleteLastEmoji()
        }
        touchableLabel.setNeedsDisplay()
    }
    
    // MARK: - Public API
    
    func selectLastSentence() {
        if sentences?.count > 0 {
            selectedSentence = sentences![sentences!.count-1]
            touchableLabel.setNeedsDisplay()
        }
    }
    
}
