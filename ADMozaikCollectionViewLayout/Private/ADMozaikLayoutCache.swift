//
//  ADMozaikLayoutCache.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 29/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

/// The `ADMozaikLayoutCache` defines the class with the purpose to reuse information from collection view and layout delegate
class ADMozaikLayoutCache {
    
    /// Stores number of sections in collection view
    fileprivate var cachedNumberOfSections: Int?
    
    /// Stores number of items in specific section
    fileprivate var cachedNumberOfItemsInSectionDictionary: [Int: Int]
    
    /// Stores number size of item at specific indexPath
    fileprivate var cachedSizeOfItemAtIndexPathDictionary: [IndexPath: ADMozaikLayoutSize]
    
    /// Reference to collectionView
    fileprivate let collectionView: UICollectionView
    
    /// Reference to mozaik layout delegate
    fileprivate let mozaikLayoutDelegate: ADMozaikLayoutDelegate
    
    ///
    /// Designated initializer for the `ADMozaikLayoutCache`
    ///
    /// - parameter collectionView:       attached to layout collection view
    /// - parameter mozaikLayoutDelegate: layout delegate
    ///
    /// - returns: newly created class `ADMozaikLayoutCache`
    init(collectionView: UICollectionView, mozaikLayoutDelegate: ADMozaikLayoutDelegate) {
        self.collectionView = collectionView
        self.mozaikLayoutDelegate = mozaikLayoutDelegate
        self.cachedNumberOfItemsInSectionDictionary = [:]
        self.cachedSizeOfItemAtIndexPathDictionary = [:]
    }
    
    //MARK: - Interface
    
    ///
    /// Returns number of items in the given section
    /// It either uses the cached value or the value from collectionView and caches it
    ///
    /// - parameter section: section number to get number of items in
    ///
    /// - returns: number of items in the given section
    func numberOfItemsInSection(_ section: Int) -> Int {
        if self.cachedNumberOfItemsInSectionDictionary[section] == nil {
            self.cachedNumberOfItemsInSectionDictionary[section] = self.collectionView.numberOfItems(inSection: section)
        }
        return self.cachedNumberOfItemsInSectionDictionary[section]!
    }
    
    ///
    /// Returns number of sections in attached collectionView
    /// It either uses the cached value or the value from collectionView and caches it
    ///
    /// - returns: number of sections in attached collectionView
    func numberOfSections() -> Int {
        if self.cachedNumberOfSections == nil {
            self.cachedNumberOfSections = self.collectionView.numberOfSections
        }
        return self.cachedNumberOfSections!
    }
    
    ///
    /// Returns size for an item at the given indexPath
    /// It either uses the cached value or the value from collectionView and caches it
    ///
    /// - parameter indexPath: index path to get the size of an item at
    ///
    /// - returns: size for an item at the given indexPath
    func mozaikSizeForItem(atIndexPath indexPath: IndexPath) -> ADMozaikLayoutSize {
        var size: ADMozaikLayoutSize? = self.cachedSizeOfItemAtIndexPathDictionary[indexPath]
        if size == nil {
            size = self.mozaikLayoutDelegate.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, mozaikSizeForItemAtIndexPath: indexPath)
        }
        return size!
    }
}
