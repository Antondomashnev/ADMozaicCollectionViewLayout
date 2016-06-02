//
//  ADMozaikLayout.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

/// The `ADMozaikLayout` defines the custom `UICollectionViewFlowLayout` subclass
public class ADMozaikLayout: UICollectionViewFlowLayout {
    
    /// Delegate for the layout. It's required
    public weak var delegate: ADMozaikLayoutDelegate!
    
    /// Columns of the layout
    public let columns: [ADMozaikLayoutColumn]
    
    /// Height of each layout's row
    public let rowHeight: CGFloat
    
    //*******************************//
    
    /// Current layout geometry
    private var layoutGeometry: ADMozaikLayoutGeometry!
    
    /// Current layout cache to speed up calculations
    private var layoutCache: ADMozaikLayoutCache!
    
    /// Current number of rows in layout
    private var rowCount: Int = 0
    
    /// Layout content height
    private var contentHeight: CGFloat = 0
    
    /// `ADMozaikLayoutMatrix` object that represents current layout
    private var layoutMatrix: ADMozaikLayoutMatrix!
    
    /// Array of `UICollectionViewLayoutAttributes`
    private var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
    
    private var unionRectsArray: [CGRect] = []
    
    private let ADMozaikLayoutUnionSize: Int = 20
    
    //*******************************//
    
    public init(rowHeight: CGFloat, columns: [ADMozaikLayoutColumn]) {
        assert(columns.count > 0)
        assert(rowHeight > 0)
        self.columns = columns
        self.rowHeight = rowHeight
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.columns = []
        self.rowHeight = 0
        super.init(coder: aDecoder)
    }
    
    //MARK: - UICollectionViewLayout
    
    public override func prepareLayout() {
        guard self.collectionView != nil else {
            fatalError("self.collectionView expected to be not nil when execute prepareLayout()")
        }
        
        guard self.delegate != nil else {
            fatalError("self.delegate expected to be not nil when execute prepareLayout()")
        }
        
        super.prepareLayout()
        self.resetLayout()
        self.layoutCache = ADMozaikLayoutCache(collectionView: self.collectionView!, mozaikLayoutDelegate: self.delegate)
        if self.layoutCache.numberOfSections() == 0 {
            return
        }
    
        self.layoutGeometry = ADMozaikLayoutGeometry(layoutColumns: self.columns, rowHeight: self.rowHeight)
        self.layoutMatrix = ADMozaikLayoutMatrix(numberOfRows: self.calculateRowsCount(), numberOfColumns: self.columns.count)
        self.layoutAttributesArray = self.buildLayoutAttributesForNumberOfSections(self.layoutCache!.numberOfSections(), withLayoutMatrix: self.layoutMatrix)
        self.unionRectsArray = self.buildUnionRectsFromLayoutAttributes(self.layoutAttributesArray)
    }
    
    public override func collectionViewContentSize() -> CGSize {
        guard self.collectionView != nil else {
            fatalError("self.collectionView expected to be not nil when execute collectionViewContentSize()")
        }
        
        let numberOfSections = self.layoutCache!.numberOfSections()
        if numberOfSections == 0 {
            return CGSizeZero
        }
        let contentSize = super.collectionViewContentSize()
        let delta = CGRectGetHeight(self.collectionView!.bounds) - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        return CGSizeMake(contentSize.width, max(self.contentHeight, delta));
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return indexPath.item < self.layoutAttributesArray.count ? nil : self.layoutAttributesArray[indexPath.item]
    }
 
    public override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
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
    
    //MARK: - Helpers
    
    private func resetLayout() {
        self.rowCount = 0
        self.contentHeight = 0
        self.unionRectsArray.removeAll()
        self.layoutAttributesArray.removeAll()
        self.layoutMatrix = nil
        self.layoutCache = nil
        self.layoutGeometry = nil
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
    
    private func buildLayoutAttributesForNumberOfSections(numberOfSections: Int, withLayoutMatrix layoutMatrix: ADMozaikLayoutMatrix) -> [UICollectionViewLayoutAttributes] {
        var allAttributes: [UICollectionViewLayoutAttributes] = []
        for section in 0..<numberOfSections {
            let itemsCount = self.layoutCache.numberOfItemsInSection(section)
            for item in 0..<itemsCount {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let itemSize = self.layoutCache.mozaikSizeForItemAtIndexPath(indexPath)
                guard let itemPosition = self.layoutMatrix.positionForItemWithSize(itemSize) else {
                    continue
                }
                let xOffset = self.layoutGeometry.xOffsetForItemAtPosition(itemPosition)
                let yOffset = self.layoutGeometry.yOffsetForItemAtPosition(itemPosition)
                let itemGeometrySize = self.layoutGeometry.sizeForItemWithMozaikSize(itemSize, atPosition: itemPosition)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemGeometrySize.width, height: itemGeometrySize.height)
                allAttributes.append(attributes)
                
                self.contentHeight = fmax(self.contentHeight, yOffset + itemGeometrySize.height)
                do {
                    try self.layoutMatrix.addItemWithSize(itemSize, atPosition: itemPosition)
                }
                catch {
                    fatalError((error as! CustomStringConvertible).description)
                }
            }
        }
        return allAttributes
    }

    private func calculateRowsCount() -> Int {
        guard self.collectionView != nil else {
            fatalError("self.collectionView expected to be not nil at that moment")
        }
        guard self.delegate != nil else {
            assertionFailure("self.delegate expected to be not nil at that moment")
            return 0
        }
        
        let numberOfSections = self.layoutCache.numberOfSections()
        var totalCells: Int = 0
        for section in 0..<numberOfSections {
            let numberOfItemsInSection = self.layoutCache.numberOfItemsInSection(section)
            for item in 0..<numberOfItemsInSection {
                let itemSize = self.layoutCache.mozaikSizeForItemAtIndexPath(NSIndexPath(forItem: item, inSection: section))
                totalCells += itemSize.totalCells()
            }
        }
        return totalCells / self.columns.count + ((totalCells % self.columns.count != 0) ? 1 : 0)
    }
    
}
