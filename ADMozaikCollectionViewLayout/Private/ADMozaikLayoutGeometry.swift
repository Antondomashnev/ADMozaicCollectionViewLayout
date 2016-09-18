//
//  ADMozaikLayoutGeometry.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 29/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation
import CoreGraphics

/// The `ADMozaikLayoutGeometry` defines the class that represent the geometry of collection view layout
class ADMozaikLayoutGeometry {
 
    /// Minimum inter item spacing
    var minimumInteritemSpacing: CGFloat = 0.0
    
    /// Minimum space between lines
    var minimumLineSpacing: CGFloat = 0.0
    
    /// Layout content height
    var contentHeight: CGFloat = 0
    
    /// Array that contains information about layout columns
    fileprivate let layoutColumns: [ADMozaikLayoutColumn]
    
    /// Row height of the layout
    fileprivate let rowHeight: CGFloat
    
    ///
    /// Initializes the layout geometry instance
    ///
    /// - parameter layoutColumns: layout columns array
    /// - parameter rowHeight:     row height of the layout
    ///
    /// - returns: newly created layout geometry instance
    init(layoutColumns: [ADMozaikLayoutColumn], rowHeight: CGFloat) {
        self.layoutColumns = layoutColumns
        self.rowHeight = rowHeight
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
            width += self.layoutColumns[column].width
        }
        width += CGFloat(size.columns - 1) * self.minimumInteritemSpacing
        let height = CGFloat(size.rows) * self.rowHeight + CGFloat(size.rows - 1) * self.minimumLineSpacing;
        return CGSize(width: width, height: height)
    }
    
    ///
    /// Calculates the x origin for the item at the given position
    ///
    /// - parameter position: position of the item in mozaik layout
    ///
    /// - returns: geometry x offset of the item
    func xOffsetForItem(at position: ADMozaikLayoutPosition) -> CGFloat {
        var xOffset: CGFloat = 0.0
        if position.column == 0 {
            return 0.0
        }
        for column in 0...position.column - 1 {
            xOffset += self.layoutColumns[column].width + self.minimumInteritemSpacing
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
        return (self.rowHeight + self.minimumLineSpacing) * CGFloat(position.row)
    }
}
