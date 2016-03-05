//
//  EntryComposer.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation

class EntryComposer: UIView {
    
    // MARK: - Public properties
    
    var entry: Entry?

    // MARK: - Private properties

    private var sentences: [Sentence]? {
        get {
            return entry?.sentences?.array as? [Sentence]
        }
    }
    private let hiddenTextView = UITextView()
    private var emojiKeyboard: EmojiKeyboard!
    private var selectedSentence: Sentence? {
        didSet {
            touchableLabel.setNeedsDisplay()
        }
    }
    private var shouldHideKeyboard = true
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
        hiddenTextView.delegate = self
        addSubview(hiddenTextView)
    }
}

// MARK: - MSPTouchableLabelDataSource

extension EntryComposer: MSPTouchableLabelDataSource {
    func textForTouchableLabel(touchableLabel: MSPTouchableLabel!) -> [AnyObject]! {
        var outputText = [String]()
        
        guard let sentences = sentences where sentences.count > 0 else {
            return outputText
        }

        for i in 0..<sentences.count {
            let sentence = sentences[i]
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
}

// MARK: - MSPTouchableLabelDelegate

extension EntryComposer: MSPTouchableLabelDelegate {
    func touchableLabel(touchableLabel: MSPTouchableLabel!, touchesDidEndAtIndex index: Int) {
        guard index >= 0 && index < sentences?.count else {
            hideKeyboard()
            return
        }

        showKeyboard()
        selectedSentence = sentences?[index]
    }
}
    
// MARK: - EmojiKeyboardDelegate

extension EntryComposer: EmojiKeyboardDelegate {
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String) {
        selectedSentence?.addEmoji(text, save: true)
        touchableLabel.setNeedsDisplay()
    }
    
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard) {
        guard let
            selectedSentence = selectedSentence,
            sentences = sentences where sentences.count > 0 else {
                return
        }

        if selectedSentence.emojiState == .Blank {
            entry?.deleteSentence(selectedSentence)
            self.selectedSentence = sentences[sentences.count-1]
        } else {
            selectedSentence.deleteLastEmojiSave(true)
        }

        touchableLabel.setNeedsDisplay()
        selectLastSentence()
    }
}

// MARK: - UITextViewDelegate

extension EntryComposer: UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }

    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return shouldHideKeyboard
    }
}

// MARK: - Public API

extension EntryComposer {
    func selectLastSentence() {
        guard let sentences = sentences where sentences.count > 0 else {
            return
        }

        selectedSentence = sentences[sentences.count-1]
        touchableLabel.setNeedsDisplay()
        showKeyboard()
    }

    func showKeyboard() {
        shouldHideKeyboard = false
        hiddenTextView.becomeFirstResponder()
    }

    func hideKeyboard() {
        shouldHideKeyboard = true
        selectedSentence = nil
        hiddenTextView.resignFirstResponder()
    }
}

// MARK: - Private implementation

extension EntryComposer {
}
