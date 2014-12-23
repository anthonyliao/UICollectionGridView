//
//  UICollectionGridVIewLayout.swift
//  UICollectionGridView
//
//  Created by anthony on 12/23/14.
//  Copyright (c) 2014 com.anthonyliao. All rights reserved.
//

import Foundation
import UIKit

class UICollectionGridViewLayout: UICollectionViewLayout {
    private var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var itemsSize: [NSValue] = []
    private var contentSize: CGSize = CGSizeZero
    var viewController: UICollectionGridViewController!
    
    override func prepareLayout() {
        if collectionView!.numberOfSections() == 0 {
            return
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        if itemAttributes.count > 0 {
            for var section = 0; section < collectionView?.numberOfSections(); section++ {
                var numberOfItems = collectionView?.numberOfItemsInSection(section)
                for var index = 0; index < numberOfItems; index++ {
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    var attributes = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: section))
                    //freeze first row, header row
                    if section == 0 {
                        var frame = attributes.frame
                        frame.origin.y = collectionView!.contentOffset.y
                        attributes.frame = frame
                    }
                }
            }
            return
        }
        
        itemAttributes = []
        itemsSize = []
        
        if itemsSize.count != viewController.cols.count {
            calculateItemsSize()
        }
        
        for var section = 0; section < collectionView?.numberOfSections(); section++ {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            for var index = 0; index < viewController.cols.count; index++ {
                var itemSize = itemsSize[index].CGSizeValue()
                
                var indexPath = NSIndexPath(forItem: index, inSection: section)
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024
                } else if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    //sticks to the top
                    var frame = attributes.frame
                    frame.origin.y = collectionView!.contentOffset.y
                    attributes.frame = frame
                }
                
                sectionAttributes.append(attributes)
                
                xOffset = xOffset+itemSize.width
                column++
                
                if column == viewController.cols.count {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            itemAttributes.append(sectionAttributes)
        }
        
        var attributes = itemAttributes.last!.last! as UICollectionViewLayoutAttributes
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        contentSize = CGSizeMake(contentWidth, contentHeight)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for section in itemAttributes {
            attributes.extend(section.filter( {(includeElement: UICollectionViewLayoutAttributes) -> Bool in
                return CGRectIntersectsRect(rect, includeElement.frame)
            }))
        }
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    func sizeForItemWithColumnIndex(columnIndex: Int, remainingWidth: CGFloat) -> CGSize {
        var columnString = viewController.cols[columnIndex]
        //Estimate the size of the column, based on column header
        var size = NSString(string: columnString).sizeWithAttributes([
            NSFontAttributeName:UIFont.systemFontOfSize(15),
            NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue
            ])
        
        if columnIndex == 0 {
            return CGSizeMake(max(remainingWidth, size.width + 17), size.height + 10)
        }
        //10 pixels of separation between columns to allow for ASC/DESC sort icon
        //10 pixels of separation between rows
        return CGSizeMake(size.width + 17, size.height + 10)
    }
    
    func calculateItemsSize() {
        var remainingWidth = collectionView!.frame.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        
        for var index = viewController.cols.count-1; index >= 0; index-- {
            var newItemSize = sizeForItemWithColumnIndex(index, remainingWidth: remainingWidth)
            remainingWidth -= newItemSize.width
            var newItemSizeValue = NSValue(CGSize: newItemSize)
            //Since we're starting from the end, insert each new element at the beginning
            itemsSize.insert(newItemSizeValue, atIndex: 0)
        }
    }
}