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
    
    //*******************************//
    
    override open var minimumLineSpacing: CGFloat {
        willSet {
            fatalError("ADMozaikLayout doesn't support setting minimumLineSpacing directly for layout. Please use ADMozaikLayoutDelegate method to return geometry info")
        }
    }
    
    override open var minimumInteritemSpacing: CGFloat {
        willSet {
            fatalError("ADMozaikLayout doesn't support setting minimumInteritemSpacing directly for layout. Please use ADMozaikLayoutDelegate method to return geometry info")
        }
    }
    
    //*******************************//
    
    /// Layout geometries array for each section
    fileprivate var layoutGeometries: [ADMozaikLayoutSectionGeometry]?
    
    /// Array of `ADMozaikLayoutSectionMatrix` objects that represents layout for each section
    fileprivate var layoutMatrixes: [ADMozaikLayoutSectionMatrix]?
    
    /// Current layout cache to speed up calculations
    fileprivate var layoutCache: ADMozaikLayoutCache?
    
    /// Keeps information about current layout attributes
    fileprivate var layoutAttrbutes: ADMozaikLayoutAttributes?
    
    /// Keeps information about current layout bounds size
    fileprivate var currentLayoutBounds: CGSize = CGSize.zero
    
    //*******************************//
    
    /// Designated initializer for `ADMozaikLayout`
    ///
    /// - Parameter delegate: delegate/datasource for the layout
    public init(delegate: ADMozaikLayoutDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    ///
    /// Initializer to create new instance of `ADMozaikLayout` from storyboard or xib
    ///
    /// - Parameter coder: encoded information about layout
    ///
    /// - Returns: newly created instance of `ADMozaikLayout`
    required public init?(coder aDecoder: NSCoder) {
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
        self.createSectionInformations()
        guard let layoutCache = self.layoutCache, let layoutMatrixes = self.layoutMatrixes, let layoutGeometries = self.layoutGeometries else {
            fatalError("layout is not prepared, because of internal setup error")
        }
        do {
            self.layoutAttrbutes = try ADMozaikLayoutAttributes(layoutCache: layoutCache, layoutMatrixes: layoutMatrixes, layoutGeometries: layoutGeometries)
        }
        catch let error {
            fatalError("Internal layout attributes error: \(error)")
        }
    }
    
    open override var collectionViewContentSize : CGSize {
        guard let collectionView = self.collectionView else {
            fatalError("self.collectionView expected to be not nil when execute collectionViewContentSize()")
        }
        guard let layoutGeometries = self.layoutGeometries else {
            return CGSize.zero
        }
        
        let numberOfSections = self.layoutCache!.numberOfSections()
        if numberOfSections == 0 {
            return CGSize.zero
        }
        let contentSize = super.collectionViewContentSize
        let delta = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        let layoutGeometriesContentHeight = layoutGeometries.reduce(0) { result, geometry in
            return result + geometry.contentHeight
        }
        return CGSize(width: contentSize.width, height: max(layoutGeometriesContentHeight, delta));
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
        return self.layoutCache != nil && self.layoutGeometries != nil && self.layoutMatrixes != nil && self.layoutAttrbutes != nil
    }
    
    fileprivate func resetLayout() {
        self.layoutAttrbutes = nil
        self.layoutCache = nil
        self.layoutMatrixes = nil
        self.layoutGeometries = nil
    }
    
    fileprivate func createSectionInformations() {
        guard let cache = self.layoutCache, let delegate = self.delegate, let collectionView = self.collectionView else {
            fatalError("createLayoutGeometries internal parameters don't satisfy requirenments: cache: \(String(describing: self.layoutCache)), delegate: \(self.delegate), collectionView = \(String(describing: self.collectionView)))")
        }
        var buildingLayoutGeometries: [ADMozaikLayoutSectionGeometry] = []
        var buildingLayoutMatrixes: [ADMozaikLayoutSectionMatrix] = []
        for section in 0..<cache.numberOfSections() {
            let sectionGeometryInfo = delegate.collectonView(collectionView, mozaik: self, geometryInfoFor: section)
            let sectionGeometry = ADMozaikLayoutSectionGeometry(geometryInfo: sectionGeometryInfo)
            buildingLayoutGeometries.append(sectionGeometry)
            let sectionMatrix = ADMozaikLayoutSectionMatrix(numberOfColumns: sectionGeometryInfo.columns.count, section: section)
            buildingLayoutMatrixes.append(sectionMatrix)
        }
        self.layoutGeometries = buildingLayoutGeometries
        self.layoutMatrixes = buildingLayoutMatrixes
    }
}

extension ADMozaikLayout {
    internal func currentDeviceOrientation() -> UIDeviceOrientation {
        return UIDevice.current.orientation
    }
}
