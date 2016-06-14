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
    
    override public var minimumLineSpacing: CGFloat {
        didSet {
            self.layoutGeometry?.minimumLineSpacing = minimumLineSpacing
        }
    }
    
    override public var minimumInteritemSpacing: CGFloat {
        didSet {
            self.layoutGeometry?.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
    
    //*******************************//
    
    /// Current layout geometry
    private var layoutGeometry: ADMozaikLayoutGeometry!
    
    /// Current layout cache to speed up calculations
    private var layoutCache: ADMozaikLayoutCache!
    
    /// `ADMozaikLayoutMatrix` object that represents current layout
    private var layoutMatrix: ADMozaikLayoutMatrix!
    
    /// Keeps information about current layout attributes
    private var layoutAttrbutes: ADMozaikLayoutAttributes!
    
    //*******************************//
    
    /**
     Designated initializer to create new instance of `ADMozaikLayout`
     
     - parameter rowHeight: height for each row
     - parameter columns:   array of `ADMozaikLayoutColumn` for the layout
     
     - returns: newly created instance of `ADMozaikLayout`
     */
    public init(rowHeight: CGFloat, columns: [ADMozaikLayoutColumn]) {
        assert(columns.count > 0)
        assert(rowHeight > 0)
        self.columns = columns
        self.rowHeight = rowHeight
        super.init()
    }
    
    /**
     Initializer to create new instance of `ADMozaikLayout` from storyboard or xib
     
     - parameter rowHeight: height for each row
     - parameter columns:   array of `ADMozaikLayoutColumn` for the layout
     
     - returns: newly created instance of `ADMozaikLayout`
     */
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
        self.layoutGeometry.minimumLineSpacing = self.minimumLineSpacing
        self.layoutGeometry.minimumInteritemSpacing = self.minimumInteritemSpacing
        self.layoutMatrix = ADMozaikLayoutMatrix(numberOfRows: self.calculateRowsCount(), numberOfColumns: self.columns.count)
        self.layoutAttrbutes = ADMozaikLayoutAttributes(layoutCache: self.layoutCache, layoutMatrix: self.layoutMatrix, layoutGeometry: self.layoutGeometry)
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
        return CGSizeMake(contentSize.width, max(self.layoutGeometry.contentHeight, delta));
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttrbutes?.layoutAttributesForItemAtIndexPath(indexPath)
    }
 
    public override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttrbutes?.layoutAttributesForElementsInRect(rect)
    }
    
    //MARK: - Helpers
    
    private func resetLayout() {
        self.layoutAttrbutes = nil
        self.layoutMatrix = nil
        self.layoutCache = nil
        self.layoutGeometry = nil
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
