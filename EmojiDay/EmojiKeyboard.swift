//
//  EmojiKeyboard.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/16/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import UIKit

let buttonSize = CGFloat(48.0)

protocol EmojiKeyboardDelegate : NSObjectProtocol {
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String)
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard)
}

class EmojiKeyboard: UIView, UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topAccentView: UIView!
    @IBOutlet weak var keysScrollView: UIScrollView!
    @IBOutlet weak var backspaceKey: UIButton!
    
    var delegate: EmojiKeyboardDelegate?
    var keys: [String] = [String]()
    var accentColor: UIColor = UIColor.blueColor()
    var numberOfKeysPerRow: Int = 0
    var numberOfKeysPerColumn: Int = 0
    var numberOfKeysPerPage: Int = 0
    var numberOfPages: Int = 0
    
    // MARK: - UIVIew
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        keysScrollView.directionalLockEnabled = true
        keysScrollView.pagingEnabled = true
        keysScrollView.showsHorizontalScrollIndicator = false
        keysScrollView.showsVerticalScrollIndicator = false
        keysScrollView.delegate = self
        
        pageControl.userInteractionEnabled = false
        pageControl.currentPage = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        numberOfKeysPerRow = Int(keysScrollView.bounds.width / buttonSize)
        numberOfKeysPerColumn = Int(keysScrollView.bounds.height / buttonSize)
        numberOfKeysPerPage = Int(numberOfKeysPerRow * numberOfKeysPerColumn)
        numberOfPages = Int(keys.count / numberOfKeysPerPage) + (keys.count % numberOfKeysPerPage > 0 ? 1 : 0)
        
        keysScrollView.contentSize = CGSizeMake(CGFloat(numberOfPages) * keysScrollView.bounds.width, keysScrollView.bounds.height)
        
        pageControl.numberOfPages = numberOfPages
        pageControl.hidden = numberOfPages <= 1
        
        topAccentView.backgroundColor = accentColor
        if let accentColorRGBComponents = accentColor.rgb() {
            pageControl.pageIndicatorTintColor = UIColor(colorLiteralRed: accentColorRGBComponents.red, green: accentColorRGBComponents.green, blue: accentColorRGBComponents.blue, alpha: accentColorRGBComponents.alpha/3)
        } else {
            pageControl.pageIndicatorTintColor = accentColor
        }
        pageControl.currentPageIndicatorTintColor = accentColor
        backspaceKey.setTitleColor(accentColor, forState: UIControlState.Normal)
        backspaceKey.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        
        layoutButtons()
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pageControl.currentPage = lroundf(Float(scrollView.contentOffset.x / scrollView.bounds.width))
    }
    
    // MARK: - ()
    
    func layoutButtons() {
        for subview in keysScrollView.subviews {
            subview.removeFromSuperview()
        }
        
        let drawPointLeftMostValue = (keysScrollView.bounds.width - (CGFloat(numberOfKeysPerRow) * buttonSize)) / 2
        var drawPoint = CGPointMake(drawPointLeftMostValue, 0)
        
        var pageOffset = 0
        
        for keyIndex in 0..<keys.count {
            let emoji = keys[keyIndex]
            
            let button = UIButton(frame: CGRectMake(drawPoint.x, drawPoint.y, buttonSize, buttonSize))
            button.setTitle(emoji, forState:UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(28.0)
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            keysScrollView.addSubview(button)
            
            drawPoint.x += buttonSize
            if ((drawPoint.x % keysScrollView.bounds.width) + buttonSize >= keysScrollView.bounds.width) {
                drawPoint.y += buttonSize
                
                if ((drawPoint.y % keysScrollView.bounds.height) + buttonSize >= keysScrollView.bounds.height) {
                    pageOffset += 1
                    drawPoint.y = 0
                }
                
                drawPoint.x = drawPointLeftMostValue + (CGFloat(pageOffset) * keysScrollView.bounds.width)
            }
        }
    }
    
    // MARK: - Actions
    
    func buttonPressed(sender: UIButton!) {
        let buttonText = sender.titleForState(UIControlState.Normal)
        if (delegate != nil) {
            delegate!.emojiKeyboard(self, didSelectButtonWithText: buttonText!)
        }
    }
    
    @IBAction func backspaceTapped(sender: AnyObject) {
        if (delegate != nil) {
            delegate!.emojiKeyboardBackspaceTapped(self)
        }
    }
}