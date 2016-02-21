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

protocol EmojiKeyboardDelegate: NSObjectProtocol {
    func emojiKeyboard(emojiKeyboard: EmojiKeyboard, didSelectButtonWithText text: String)
    func emojiKeyboardBackspaceTapped(emojiKeyboard: EmojiKeyboard)
}

protocol EmojiKeyboardDataSource: NSObjectProtocol {
    func sectionsForEmojiKeyboard(emojiKeyboard: EmojiKeyboard) -> [EmojiKeyboardSection]
}

class EmojiKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var topAccentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backspaceKey: UIButton!
    @IBOutlet weak var pageControl: SMPageControl!
    
    var dataSource: EmojiKeyboardDataSource = EmojiKeyboardValues.sharedInstance
    var delegate: EmojiKeyboardDelegate?
    var showRecentSection = false
    var numberOfKeysPerColumn = 5
    var accentColor = UIColor.blueColor()
    var unselectedColor = UIColor.grayColor()
    var numberOfPages = 8
    
    // MARK: - UIVIew
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        autoresizingMask = UIViewAutoresizing.None  // honor our own frame instead of being forced into the system keyboard frame
        let screenSize = UIScreen.mainScreen().bounds
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: screenSize.height / 2)
        
        let layout = EmojiKeyboardCollectionViewLayout()
        
        collectionView.collectionViewLayout = layout
        collectionView.registerNib(UINib.init(nibName: "EmojiKeyboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EmojiKeyboardCollectionViewCell.reuseIdentifier)
        collectionView.registerNib(UINib.init(nibName: "EmojiKeyboardSectionHeaderSupplementaryView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EmojiKeyboardSectionHeaderSupplementaryView.reuseIdentifier)
        collectionView.backgroundColor = self.backgroundColor

        pageControl.tapBehavior = SMPageControlTapBehavior.Jump
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageControl.numberOfPages = numberOfPages
        pageControl.hidesForSinglePage = true
        
        topAccentView.backgroundColor = accentColor
        backspaceKey.setTitleColor(accentColor, forState: UIControlState.Normal)
        backspaceKey.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        
        let layout = collectionView.collectionViewLayout as? EmojiKeyboardCollectionViewLayout
        layout?.itemSize = sizeForKeyboardButtons()

        var i = 0
        let _ = dataSource.sectionsForEmojiKeyboard(self).map{
            pageControl.setImage(UIImage.newImageFromMaskImage($0.selectedIcon, inColor: unselectedColor), forPage: i)
            pageControl.setCurrentImage(UIImage.newImageFromMaskImage($0.selectedIcon, inColor: accentColor), forPage: i)
            i++
        }
        
        pageControl.indicatorDiameter = pageControl.bounds.width / CGFloat(pageControl.numberOfPages)
        pageControl.indicatorMargin = 0
        pageControl.currentPage = 0
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.sectionsForEmojiKeyboard(self)[section].emojis.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.sectionsForEmojiKeyboard(self).count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: EmojiKeyboardSectionHeaderSupplementaryView.reuseIdentifier, forIndexPath: indexPath) as? EmojiKeyboardSectionHeaderSupplementaryView else {
            fatalError()
        }
        
        let section = dataSource.sectionsForEmojiKeyboard(self)[indexPath.section]
        header.titleLabel.text = section.title.uppercaseString
        header.titleLabel.font = UIFont.boldSystemFontOfSize(12)
        header.titleLabel.textColor = UIColor.grayColor()
        
        return header
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmojiKeyboardCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? EmojiKeyboardCollectionViewCell else {
            fatalError()
        }
        
        let section = dataSource.sectionsForEmojiKeyboard(self)[indexPath.section]
        let emoji = section.emojis[indexPath.row]
        cell.emojiLabel.text = emoji.value
        cell.backgroundColor = self.backgroundColor
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let section = dataSource.sectionsForEmojiKeyboard(self)[indexPath.section]
        let emoji = section.emojis[indexPath.row]
        if delegate != nil {
            delegate!.emojiKeyboard(self, didSelectButtonWithText: emoji.value)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let point = CGPoint(x: (collectionView.contentOffset.x + collectionView.frame.size.width/2), y: (collectionView.frame.origin.y + collectionView.frame.size.height/2))
        if let indexPath = collectionView.indexPathForItemAtPoint(point) {
            pageControl.currentPage = indexPath.section
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backspaceTapped(sender: AnyObject) {
        if delegate != nil {
            delegate!.emojiKeyboardBackspaceTapped(self)
        }
    }
    
    @IBAction func pageChanged(sender: AnyObject) {
        let indexPath = NSIndexPath(forItem: 0, inSection: pageControl.currentPage)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    // MARK: - Private implementation
    
    private func sizeForKeyboardButtons() -> CGSize {
        // TODO: enforce minimum button size per ios usability guidelines
        guard let layout = collectionView.collectionViewLayout as? EmojiKeyboardCollectionViewLayout  else {
            return CGSizeZero
        }

        let collectionViewHeight = collectionView.bounds.height
        let contentViewHeight = collectionViewHeight - layout.headerHeight
        let cellSizeHeightAndWidth = contentViewHeight / CGFloat(numberOfKeysPerColumn)
        
        return CGSize(width: cellSizeHeightAndWidth, height: cellSizeHeightAndWidth)
    }
}
