//
//  ADMozaikLayoutSectionGeometry.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 29/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation
import CoreGraphics

/// The `ADMozaikLayoutSectionGeometry` defines the class that represent the geometry of collection view layout
class ADMozaikLayoutSectionGeometry {
    
    /// Layout content height
    var contentHeight: CGFloat = 0
    
    /// Sections geometry information
    fileprivate let geometryInfo: ADMozaikLayoutSectionGeometryInfo
    
    ///
    /// Initializes the layout geometry instance
    ///
    /// - parameter geometryInfo: section geometry information
    ///
    /// - returns: newly created layout geometry instance
    init(geometryInfo: ADMozaikLayoutSectionGeometryInfo) {
        self.geometryInfo = geometryInfo
    }
    
    //MARK: - Interface
 
    ///
    /// Calculates the geometry size in points for the item with the given size at the given position
    ///
    /// - parameter size:     size of the item in terms of mozaik layout
    /// - parameter position: position of the item in mozaik layout
    ///
    /// - returns: geometry size of the item
    func sizeForItem(withMozaikSize size: ADMozaikLayoutSize, at position: ADMozaikLayoutPosition) -> CGSize {
        var width: CGFloat = 0.0
        for column in position.column...(position.column + size.columns - 1) {
            width += geometryInfo.columns[column].width
        }
        width += CGFloat(size.columns - 1) * geometryInfo.minimumInteritemSpacing
        let height = CGFloat(size.rows) * geometryInfo.rowHeight + CGFloat(size.rows - 1) * geometryInfo.minimumLineSpacing;
        return CGSize(width: width, height: height)
    }
    
    ///
    /// Calculates the x origin for the item at the given position
    ///
    /// - parameter position: position of the item in mozaik layout
    ///
    /// - returns: geometry x offset of the item
    func xOffsetForItem(at position: ADMozaikLayoutPosition) -> CGFloat {
        var xOffset: CGFloat = geometryInfo.sectionInset.left
        if position.column == 0 {
            return xOffset
        }
        for column in 0...position.column - 1 {
            xOffset += geometryInfo.columns[column].width + geometryInfo.minimumInteritemSpacing
        }
        return xOffset
    }
    
    ///
    /// Calculates the y origin for the item at the given position
    ///
    /// - parameter position: position of the item in mozaik layout
    ///
    /// - returns: geometry y offset of the item
    func yOffsetForItem(at position: ADMozaikLayoutPosition) -> CGFloat {
        return (geometryInfo.rowHeight + geometryInfo.minimumLineSpacing) * CGFloat(position.row) + geometryInfo.sectionInset.top
    }
}
