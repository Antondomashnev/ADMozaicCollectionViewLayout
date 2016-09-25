//
//  ADMozaikLayout.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

/// The `ADMozaikLayout` defines the custom `UICollectionViewFlowLayout` subclass
open class ADMozaikLayout: UICollectionViewFlowLayout {
    
    /// Delegate for the layout. It's required
    open weak var delegate: ADMozaikLayoutDelegate!
    
    /// Columns of the layout
    /// Deprecated
    open var columns: [ADMozaikLayoutColumn] {
        get {
            return self.geometryInfo.columns
        }
    }
    
    /// Height of each layout's row
    /// Deprecated
    open var rowHeight: CGFloat {
        get {
            return self.geometryInfo.rowHeight
        }
    }
    
    /// Current geometry info of the layout
    private(set) open var geometryInfo: ADMozaikLayoutGeometryInfo
    
    //*******************************//
    
    override open var minimumLineSpacing: CGFloat {
        didSet {
            self.layoutGeometry?.minimumLineSpacing = minimumLineSpacing
        }
    }
    
    override open var minimumInteritemSpacing: CGFloat {
        didSet {
            self.layoutGeometry?.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
    
    //*******************************//
    
    /// Current layout geometry
    fileprivate var layoutGeometry: ADMozaikLayoutGeometry?
    
    /// Current layout cache to speed up calculations
    fileprivate var layoutCache: ADMozaikLayoutCache?
    
    /// `ADMozaikLayoutMatrix` object that represents current layout
    fileprivate var layoutMatrix: ADMozaikLayoutMatrix?
    
    /// Keeps information about current layout attributes
    fileprivate var layoutAttrbutes: ADMozaikLayoutAttributes?
    
    /// Keeps information about current layout bounds size
    fileprivate var currentLayoutBounds: CGSize = CGSize.zero
    
    //*******************************//
    
    ///
    /// Designated initializer to create new instance of `ADMozaikLayout`
    /// This geometry info will be used as a default for all missing orienations
    ///
    /// - parameter geometryInfo: information about layout geometry
    /// - parameter orientation: for which orientation apply the given geometry info
    ///
    /// - returns: newly created instance of `ADMozaikLayout`
    public init(geometryInfo: ADMozaikLayoutGeometryInfo, for deviceOrientation: UIDeviceOrientation) {
        guard geometryInfo.isValid() else {
            fatalError("geometryInfo must be valid")
        }
        self.geometryInfo = geometryInfo
        super.init()
    }
    
    ///
    /// Designated initializer to create new instance of `ADMozaikLayout`
    ///
    /// - parameter rowHeight: height for each row
    /// - parameter columns:   array of `ADMozaikLayoutColumn` for the layout
    ///
    /// - returns: newly created instance of `ADMozaikLayout`
    /// Deprecated
    public convenience init(rowHeight: CGFloat, columns: [ADMozaikLayoutColumn]) {
        let geometryInfo = ADMozaikLayoutGeometryInfo(rowHeight: rowHeight, columns: columns)
        self.init(geometryInfo: geometryInfo, for: UIDeviceOrientation.portrait)
    }
    
    ///
    /// Initializer to create new instance of `ADMozaikLayout` from storyboard or xib
    ///
    /// - parameter coder: encoded information about layout
    ///
    /// - returns: newly created instance of `ADMozaikLayout`
    required public init?(coder aDecoder: NSCoder) {
        let geometryInfo = ADMozaikLayoutGeometryInfo(rowHeight: 1, columns: [])
        self.geometryInfo = geometryInfo
        super.init(coder: aDecoder)
    }
    
    //MARK: - UICollectionViewLayout
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return self.currentLayoutBounds != newBounds.size
    }
    
    open override func invalidateLayout() {
        super.invalidateLayout()
        self.resetLayout()
    }
    
    open override func prepare() {
        guard let collectionView = self.collectionView else {
            fatalError("self.collectionView expected to be not nil when execute prepareLayout()")
        }
        
        guard self.delegate != nil else {
            fatalError("self.delegate expected to be not nil when execute prepareLayout()")
        }
        super.prepare()
        if self.isLayoutReady() {
            return
        }
        
        self.currentLayoutBounds = collectionView.bounds.size
        self.layoutCache = ADMozaikLayoutCache(collectionView: collectionView, mozaikLayoutDelegate: self.delegate)
        if self.layoutCache?.numberOfSections() == 0 {
            return
        }
        
        self.layoutGeometry = ADMozaikLayoutGeometry(layoutColumns: self.geometryInfo.columns, rowHeight: self.geometryInfo.rowHeight)
        self.layoutGeometry?.minimumLineSpacing = self.minimumLineSpacing
        self.layoutGeometry?.minimumInteritemSpacing = self.minimumInteritemSpacing
        self.layoutMatrix = ADMozaikLayoutMatrix(numberOfColumns: self.geometryInfo.columns.count)
        if let layoutCache = self.layoutCache, let layoutMatrix = self.layoutMatrix, let layoutGeometry = self.layoutGeometry {
            self.layoutAttrbutes = ADMozaikLayoutAttributes(layoutCache: layoutCache, layoutMatrix: layoutMatrix, layoutGeometry: layoutGeometry)
        }
        
    }
    
    open override var collectionViewContentSize : CGSize {
        guard self.collectionView != nil else {
            fatalError("self.collectionView expected to be not nil when execute collectionViewContentSize()")
        }
        guard let layoutGeometry = self.layoutGeometry else {
            return CGSize.zero
        }
        
        let numberOfSections = self.layoutCache!.numberOfSections()
        if numberOfSections == 0 {
            return CGSize.zero
        }
        let contentSize = super.collectionViewContentSize
        let delta = self.collectionView!.bounds.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        return CGSize(width: contentSize.width, height: max(layoutGeometry.contentHeight, delta));
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttrbutes?.layoutAttributesForItem(at: indexPath)
    }
 
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttrbutes?.layoutAttributesForElementsInRect(rect)
    }
    
    //MARK: - Helpers
    
    fileprivate func isLayoutReady() -> Bool {
        return self.layoutCache != nil && self.layoutGeometry != nil && self.layoutMatrix != nil && self.layoutAttrbutes != nil
    }
    
    fileprivate func resetLayout() {
        self.layoutAttrbutes = nil
        self.layoutMatrix = nil
        self.layoutCache = nil
        self.layoutGeometry = nil
    }
}

extension ADMozaikLayout {
    internal func currentDeviceOrientation() -> UIDeviceOrientation {
        return UIDevice.current.orientation
    }
}
