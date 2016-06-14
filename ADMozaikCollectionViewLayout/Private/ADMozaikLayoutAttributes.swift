//
//  ADMozaikLayoutAttributes.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 14/06/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

class ADMozaikLayoutAttributes {
    
    /// Array of `UICollectionViewLayoutAttributes`
    private(set) var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
    
    /// Array of unified rects of each 20 layout attributes
    private(set) var unionRectsArray: [CGRect] = []
    
    /// Default number of attributes in one union
    private let ADMozaikLayoutUnionSize: Int = 20
    
    init(layoutCache: ADMozaikLayoutCache, layoutMatrix: ADMozaikLayoutMatrix, layoutGeometry: ADMozaikLayoutGeometry) {
        self.layoutAttributesArray = self.buildLayoutAttributesForLayoutGeometry(layoutGeometry, withLayoutMatrix: layoutMatrix, andLayoutCache: layoutCache)
        self.unionRectsArray = self.buildUnionRectsFromLayoutAttributes(self.layoutAttributesArray)
    }
    
    //MARK: - Interface
    
    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return indexPath.item < self.layoutAttributesArray.count ? nil : self.layoutAttributesArray[indexPath.item]
    }
    
    func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultAttributes: [UICollectionViewLayoutAttributes] = []
        let unionRectsCount = self.unionRectsArray.count
        var begin = 0
        var end = unionRectsCount
        
        for unionRectIndex in (0..<unionRectsCount) {
            if !CGRectIntersectsRect(rect, self.unionRectsArray[unionRectIndex]) {
                continue
            }
            begin = unionRectIndex * ADMozaikLayoutUnionSize
            break
        }
        
        for unionRectIndex in (0..<unionRectsCount).reverse() {
            if !CGRectIntersectsRect(rect, self.unionRectsArray[unionRectIndex]) {
                continue
            }
            end = min((unionRectIndex + 1) * ADMozaikLayoutUnionSize, self.layoutAttributesArray.count)
            break
        }
        
        for i in begin..<end {
            let attributes = self.layoutAttributesArray[i]
            if CGRectIntersectsRect(rect, attributes.frame) {
                resultAttributes.append(attributes)
            }
        }
        
        return resultAttributes
    }
    
    //MARK: - Helper
    
    private func buildLayoutAttributesForLayoutGeometry(layoutGeometry: ADMozaikLayoutGeometry, withLayoutMatrix layoutMatrix: ADMozaikLayoutMatrix, andLayoutCache layoutCache: ADMozaikLayoutCache) -> [UICollectionViewLayoutAttributes] {
        let numberOfSections = layoutCache.numberOfSections()
        var allAttributes: [UICollectionViewLayoutAttributes] = []
        var currentItemBottom: CGFloat = 0
        for section in 0..<numberOfSections {
            let itemsCount = layoutCache.numberOfItemsInSection(section)
            for item in 0..<itemsCount {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let itemSize = layoutCache.mozaikSizeForItemAtIndexPath(indexPath)
                guard let itemPosition = layoutMatrix.positionForItemWithSize(itemSize) else {
                    continue
                }
                let xOffset = layoutGeometry.xOffsetForItemAtPosition(itemPosition)
                let yOffset = layoutGeometry.yOffsetForItemAtPosition(itemPosition)
                let itemGeometrySize = layoutGeometry.sizeForItemWithMozaikSize(itemSize, atPosition: itemPosition)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemGeometrySize.width, height: itemGeometrySize.height)
                allAttributes.append(attributes)
                currentItemBottom = CGRectGetMaxY(attributes.frame)
                
                do {
                    try layoutMatrix.addItemWithSize(itemSize, atPosition: itemPosition)
                }
                catch {
                    fatalError((error as! CustomStringConvertible).description)
                }
            }
        }
        layoutGeometry.contentHeight = fmax(layoutGeometry.contentHeight, currentItemBottom)
        return allAttributes
    }
    
    private func buildUnionRectsFromLayoutAttributes(attributes: [UICollectionViewLayoutAttributes]) -> [CGRect] {
        var index = 0
        var unionRectsArray: [CGRect] = []
        let itemsCount = attributes.count
        while index < itemsCount {
            let frame1 = attributes[index].frame
            index = min(index + ADMozaikLayoutUnionSize, itemsCount) - 1
            let frame2 = attributes[index].frame
            unionRectsArray.append(CGRectUnion(frame1, frame2))
            index += 1
        }
        return unionRectsArray
    }
    
}
