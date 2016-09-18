//
//  ADMozaikLayoutDelegate.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

/// The `ADMozaikLayoutDelegate` defines the protocol that let you implement a mozaik layout for `UICollectionView`
public protocol ADMozaikLayoutDelegate: UICollectionViewDelegateFlowLayout {
    
    ///
    /// Method should return `ADMozaikLayoutSize` for specific indexPath
    ///
    /// - parameter collectionView: collection view is using layout
    /// - parameter layout:         layout itself
    /// - parameter indexPath:      indexPath of item for the size it asks for
    ///
    /// - returns: `ADMozaikLayoutSize` struct object describes the size
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, mozaikSizeForItemAtIndexPath indexPath: IndexPath) -> ADMozaikLayoutSize
}
