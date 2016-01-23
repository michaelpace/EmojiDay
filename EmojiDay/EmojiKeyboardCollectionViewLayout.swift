//
//  EmojiKeyboardCollectionViewLayout.swift
//  EmojiDay
//
//  Created by Michael Pace on 1/7/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//

import Foundation

class EmojiKeyboardCollectionViewLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties
    
    let headerHeight = CGFloat(20)
    let headerWidth = CGFloat(200)
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        headerReferenceSize = CGSize(width: headerWidth, height: headerHeight)
    }
    
    override init() {
        super.init()
        
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        headerReferenceSize = CGSize(width: headerWidth, height: headerHeight)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElementsInRect(rect)
        let section = CGFloat((attributes!.last?.indexPath.section)!)
        let newRect = CGRect(x: (collectionView?.contentOffset.x)! + (headerWidth * section), y: rect.origin.y, width: rect.size.width * 1.5, height: rect.size.height)  // TODO: why do i have to use the contentOffset.x instead of rect.origin.x, and why do i have to mulitply the rect width by 1.5? (try removing these to see the bugginess). this is really dirty. find a way to fix it.
        attributes = super.layoutAttributesForElementsInRect(newRect)
        
        var newAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in attributes! {
            // per http://stackoverflow.com/a/13389461
            if attribute.frame.origin.x + attribute.frame.size.width > collectionViewContentSize().width || attribute.frame.origin.y > collectionViewContentSize().height {
                continue
            }
            if attribute.representedElementCategory == UICollectionElementCategory.SupplementaryView {
                newAttributes.append(modifyHeaderAttributes(attribute))
            } else if attribute.representedElementCategory == UICollectionElementCategory.Cell {
                newAttributes.append(modifyCellAttributes(attribute))
            } else {
                newAttributes.append(attribute)
            }
        }
        
        return newAttributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.layoutAttributesForDecorationViewOfKind(elementKind, atIndexPath: indexPath)
        
        if elementKind == UICollectionElementKindSectionHeader {
            attributes = modifyHeaderAttributes(attributes!)
        }
        
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.layoutAttributesForItemAtIndexPath(indexPath)!
        attributes = modifyCellAttributes(attributes)
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func collectionViewContentSize() -> CGSize {
        // 259 columns
        // 51.1 width
        var contentSize = super.collectionViewContentSize()
        contentSize.width = 295 * 51.1
        return contentSize
    }
    
    // MARK: - Private implementation
    
    private func modifyHeaderAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes  // swiftlint:disable:this force_cast
        
        newAttributes.frame = CGRect(x: attributes.frame.origin.x - (headerWidth * CGFloat(attributes.indexPath.section)),
            y: 0,
            width: headerWidth,
            height: headerHeight)
        
        return newAttributes
    }
    
    private func modifyCellAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes  // swiftlint:disable:this force_cast
        let section = attributes.indexPath.section
        let rowInColumn = attributes.indexPath.row % 5
        
        // TODO: data-drive the 5 (used in computing rowInColumn) and the 10 below. the 5 comes from the EmojiKeyboard.numberOfKeysPerColumn. set keys to have green bg and collection view to have white bg to see where the 10 comes in.
        newAttributes.frame = CGRect(x: attributes.frame.origin.x - (headerWidth * CGFloat(section + 1)),
            y: attributes.frame.origin.y + headerHeight - CGFloat(rowInColumn * 10),
            width: attributes.frame.size.width,
            height: attributes.frame.size.height)
        
        return newAttributes
    }
    
}
