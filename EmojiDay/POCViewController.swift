//
//  POCViewController.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/16/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

/*

rules:
- tap a button to add a sentence.
    - create a Sentence.
    - set its order.
- keyboard appears with appropriate emoji.
- backspace to delete the sentence.
- tap screen to dismiss keyboard. also deletes sentences which aren't completed.
- drag sentences to rearrange.

*/

import UIKit
import CoreData

let firstEmoji = 0x1F600
let lastEmoji = 0x1F64F

class POCViewController: UIViewController, EmojiKeyboardDelegate, MSPTouchableLabelDataSource, MSPTouchableLabelDelegate {

    @IBOutlet weak var touchableLabel: MSPTouchableLabel!
    
    var diaryText: Array<String> = Array()
    let hiddenTextView = UITextView()
    let managedObjectContext = DataHelpers.sharedInstance.managedObjectContext
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emojiKeyboard = NSBundle.mainBundle().loadNibNamed("EmojiKeyboard", owner: self, options: nil).first as! EmojiKeyboard
        emojiKeyboard.delegate = self
        emojiKeyboard.backgroundColor = UIColor(colorLiteralRed: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        emojiKeyboard.accentColor = accentColor
        
        for i in firstEmoji...lastEmoji {
            emojiKeyboard.keys.append(String(UnicodeScalar(i)))
        }
        
        touchableLabel.dataSource = self
        touchableLabel.delegate = self
        
        hiddenTextView.inputView = emojiKeyboard
        hiddenTextView.hidden = true
        self.view.addSubview(hiddenTextView)
        
        let request = Entry.sortedFetchRequest
        request.fetchBatchSize = 20
    }
    
    // MARK: EmojiKeyboardDelegate
    
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String) {
        diaryText.popLast()
        diaryText.append(text + ". ")
        touchableLabel.setNeedsDisplay()
    }
    
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard) {
        diaryText.popLast()
        touchableLabel.setNeedsDisplay()
    }
    
    // MARK: MSPTouchableLabelDataSource
    
    func textForTouchableLabel(touchableLabel: MSPTouchableLabel!) -> [AnyObject]! {
        return diaryText
    }
    
    // MARK: MSPTouchableLabelDelegate
    
    func touchableLabel(touchableLabel: MSPTouchableLabel!, touchesDidEndAtIndex index: Int) {
        hiddenTextView.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    @IBAction func moodTapped(sender: AnyObject) {
        diaryText.append("Felt ")
        diaryText.append("______. ")
        touchableLabel.setNeedsDisplay()
    }
    
    @IBAction func weatherTapped(sender: AnyObject) {
        diaryText.append("It was ")
        diaryText.append("______. ")
        touchableLabel.setNeedsDisplay()
    }
    
    @IBAction func foodTapped(sender: AnyObject) {
        diaryText.append("Ate ")
        diaryText.append("______. ")
        touchableLabel.setNeedsDisplay()
    }
    
    @IBAction func socialTapped(sender: AnyObject) {
        diaryText.append("Saw ")
        diaryText.append("______. ")
        touchableLabel.setNeedsDisplay()
    }
    
    
}

