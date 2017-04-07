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
    
    /// Method should return `ADMozaikLayoutSize` for specific indexPath
    ///
    /// - Parameter collectionView: collection view is using layout
    /// - Parameter layout:         layout itself
    /// - Parameter indexPath:      indexPath of item for the size it asks for
    ///
    /// - Returns: `ADMozaikLayoutSize` struct object describes the size
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize
    
    /// Method should return `ADMozaikLayoutSectionGeometryInfo` to describe specific section's geometry
    ///
    /// - Parameters:
    ///   - collectionView: collection view is using layout
    ///   - layoyt:         layout itself
    ///   - section:        section to calculate geometry info for
    ///
    /// - Returns: `ADMozaikLayoutSectionGeometryInfo` struct object describes the section's geometry
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo
}
